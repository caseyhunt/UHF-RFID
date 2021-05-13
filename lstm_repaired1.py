# -*- coding: utf-8 -*-
"""
Created on Sun Apr 11 12:00:11 2021

@author: hsbbd
"""

import pandas as pd
import numpy as np
import pickle
import matplotlib.pyplot as plt
from scipy import stats
import tensorflow as tf
import seaborn as sns
from pylab import rcParams
from sklearn import metrics
from sklearn.model_selection import train_test_split

tf.compat.v1.disable_eager_execution()

data = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/recorder/recorder/laying_11May21/laying_mean_var_compiled.csv', header=0)

n_time_steps = 50
n_features = 3
step = 1
segments = []
labels = []
RANDOM_SEED = 42

for i in range(0, len(data) - n_time_steps, step):
    RSSI = data['mean'].values[i: i + n_time_steps] 
    phase = data['tag_id'].values[i: i + n_time_steps]
    variance = data['variance'].values[i:i+n_time_steps]
    #phase= data['id'].values[i: i + n_time_steps]
    label = stats.mode(data['activity'][i: i + n_time_steps])[0][0]
    #label = data['activity'][i]
    segments.append([phase,RSSI,variance])
    labels.append(label)

print(np.array(segments).shape)



reshaped_segments = np.asarray(segments).reshape(-1, n_time_steps, n_features)
labels = np.asarray(pd.get_dummies(labels))

print(np.array(reshaped_segments).shape)


RSSI_train, RSSI_test, phase_train, phase_test = train_test_split(
        reshaped_segments, labels, test_size=0.2, random_state=RANDOM_SEED)

print(labels.shape)
print(RSSI_test.shape)
print(phase_test.shape)
print(labels)

N_CLASSES = 6
N_HIDDEN_UNITS = 64
def create_LSTM_model(inputs):
    W = {
        'hidden': tf.Variable(tf.random.normal([n_features, N_HIDDEN_UNITS])),
        'output': tf.Variable(tf.random.normal([N_HIDDEN_UNITS, N_CLASSES]))
    }
    biases = {
        'hidden': tf.Variable(tf.random.normal([N_HIDDEN_UNITS], mean=1.0)),
        'output': tf.Variable(tf.random.normal([N_CLASSES]))
    }
    
    X = tf.transpose(a=inputs, perm=[1, 0, 2])
    X = tf.reshape(X, [-1, n_features])
    hidden = tf.nn.relu(tf.matmul(X, W['hidden']) + biases['hidden'])
    hidden = tf.split(hidden, n_time_steps, 0)

    # Stack 2 LSTM layers
    lstm_layers = [tf.compat.v1.nn.rnn_cell.BasicLSTMCell(N_HIDDEN_UNITS, forget_bias=1.0) for _ in range(2)]
    lstm_layers = tf.compat.v1.nn.rnn_cell.MultiRNNCell(lstm_layers)

    outputs, _ = tf.compat.v1.nn.static_rnn(lstm_layers, hidden, dtype=tf.float32)

    # Get output for the last time step
    lstm_last_output = outputs[-1]

    return tf.matmul(lstm_last_output, W['output']) + biases['output']

tf.compat.v1.reset_default_graph()

X = tf.compat.v1.placeholder(tf.float32, [None, n_time_steps, n_features], name="input")
Y = tf.compat.v1.placeholder(tf.float32, [None, N_CLASSES])

pred_Y = create_LSTM_model(X)

pred_softmax = tf.nn.softmax(pred_Y, name="y_")

L2_LOSS = 0.0015

l2 = L2_LOSS * \
    sum(tf.nn.l2_loss(tf_var) for tf_var in tf.compat.v1.trainable_variables())

loss = tf.reduce_mean(input_tensor=tf.nn.softmax_cross_entropy_with_logits(logits = pred_Y, labels = tf.stop_gradient( Y))) + l2

LEARNING_RATE = 0.0025

optimizer = tf.compat.v1.train.AdamOptimizer(learning_rate=LEARNING_RATE).minimize(loss)

correct_pred = tf.equal(tf.argmax(input=pred_softmax, axis=1), tf.argmax(input=Y, axis=1))
accuracy = tf.reduce_mean(input_tensor=tf.cast(correct_pred, dtype=tf.float32))

N_EPOCHS = 15 0
BATCH_SIZE = 1024
saver = tf.compat.v1.train.Saver()

history = dict(train_loss=[], 
                      train_acc=[], 
                      test_loss=[], 
                      test_acc=[])

sess=tf.compat.v1.InteractiveSession()
sess.run(tf.compat.v1.global_variables_initializer())

train_count = len(RSSI_train)

for i in range(1, N_EPOCHS + 1):
    for start, end in zip(range(0, train_count, BATCH_SIZE),
                          range(BATCH_SIZE, train_count + 1,BATCH_SIZE)):
        sess.run(optimizer, feed_dict={X: RSSI_train[start:end],
                                        Y: phase_train[start:end]})

    _, acc_train, loss_train = sess.run([pred_softmax, accuracy, loss], feed_dict={
                                            X: RSSI_train, Y: phase_train})

    _, acc_test, loss_test = sess.run([pred_softmax, accuracy, loss], feed_dict={
                                            X: RSSI_test, Y: phase_test})
    
    history['train_loss'].append(loss_train)
    history['train_acc'].append(acc_train)
    history['test_loss'].append(loss_test)
    history['test_acc'].append(acc_test)

    if i != 1 and i % 10 != 0:
        continue

    print(f'epoch: {i} test accuracy: {acc_test} loss: {loss_test}')
    
predictions, acc_final, loss_final = sess.run([pred_softmax, accuracy, loss], feed_dict={X: RSSI_test, Y: phase_test})

print()
print(f'final results: accuracy: {acc_final} loss: {loss_final}')


pickle.dump(predictions, open("C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/predictions.p", "wb"))
pickle.dump(history, open("C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/history.p", "wb"))
tf.io.write_graph(sess.graph_def, '.', 'C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/checkpoint/har.pbtxt')  
saver.save(sess, save_path = "C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/checkpoint/har.ckpt")
sess.close()

history = pickle.load(open("C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/history.p", "rb"))
predictions = pickle.load(open("C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/predictions.p", "rb"))

plt.figure(figsize=(12, 8))
plt.plot(np.array(history['train_loss']), "r--", label="Train loss")
plt.plot(np.array(history['train_acc']), "g--", label="Train accuracy")
plt.plot(np.array(history['test_loss']), "r-", label="Test loss")
plt.plot(np.array(history['test_acc']), "g-", label="Test accuracy")
plt.title("Training session's progress over iterations")
plt.legend(loc='upper right', shadow=True)
plt.ylabel('Training Progress (Loss or Accuracy values)')
plt.xlabel('Training Epoch')
plt.ylim(0)
plt.show()

LABELS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
max_test = np.argmax(phase_test, axis=1)
max_predictions = np.argmax(predictions, axis=1)
confusion_matrix = metrics.confusion_matrix(max_test, max_predictions)
plt.figure(figsize=(16, 14))
sns.heatmap(confusion_matrix, xticklabels=LABELS, yticklabels=LABELS, annot=True, fmt="d");
plt.title("Confusion matrix")
plt.ylabel('True label')
plt.xlabel('Predicted label')
plt.show();