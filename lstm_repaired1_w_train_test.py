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

train = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/training-2-4-7-10.csv', header=0)
test = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/testing-2-4-7-10.csv', header=0)
data = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined_noduplicates_no3.csv', header=0)

n_time_steps = 120
n_features = 2
step = 1
segments_train = []
segments_test = []
labels_train = []
labels_test = []
std_train = [0]
RANDOM_SEED = 42

for i in range(0, len(train) - n_time_steps, step):
    RSSI_train = train['RSSI'].values[i: i + n_time_steps] 
    phase_train = data['phase'].values[i: i + n_time_steps]
    stddev= np.std(RSSI_train)
    for j in range(0, n_time_steps):
        if j==0:
            std_train = [stddev]
        else:
            std_train.append(stddev)
    id_train = train['id'].values[i: i + n_time_steps]
    label_train = stats.mode(train['activity'][i: i + n_time_steps])[0][0]
    #label = data['activity'][i]
    print(label_train)
    segments_train.append([RSSI_train, id_train])
    labels_train.append(label_train)

print(np.array(segments_train).shape)



reshaped_segments_train = np.asarray(segments_train).reshape(-1, n_time_steps, n_features)
labels_train = np.asarray(pd.get_dummies(labels_train))

print(np.array(reshaped_segments_train).shape)


for i in range(0, len(test) - n_time_steps, step):
    RSSI_test = test['RSSI'].values[i: i + n_time_steps] 
    phase_test = data['phase'].values[i: i + n_time_steps]
    stddev= np.std(RSSI_test)
    for j in range(0, n_time_steps):
        if j==0:
            std_test = [stddev]
        else:
            std_test.append(stddev)
    id_test = test['id'].values[i: i + n_time_steps]
    label_test = stats.mode(test['activity'][i: i + n_time_steps])[0][0]
    #label = data['activity'][i]
    segments_test.append([RSSI_test, id_test])
    labels_test.append(label_test)

print(np.array(segments_test).shape)



reshaped_segments_test = np.asarray(segments_test).reshape(-1, n_time_steps, n_features)
labels_test = np.asarray(pd.get_dummies(labels_test))

print(np.array(reshaped_segments_test).shape)


phase_train = labels_train
phase_test = labels_test
RSSI_train = reshaped_segments_train
RSSI_test = reshaped_segments_test
print(phase_train.shape)
print(RSSI_train.shape)



# RSSI_train, RSSI_test, phase_train, phase_test = train_test_split(
#         reshaped_segments, labels, test_size=0.2, random_state=RANDOM_SEED)

N_CLASSES = 4
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

N_EPOCHS = 130
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

#LABELS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
LABELS = [2,4,7,10]
max_test = np.argmax(phase_test, axis=1)
max_predictions = np.argmax(predictions, axis=1)
confusion_matrix = metrics.confusion_matrix(max_test, max_predictions)
plt.figure(figsize=(16, 14))
sns.heatmap(confusion_matrix, xticklabels=LABELS, yticklabels=LABELS, annot=True, fmt="d");
plt.title("Confusion matrix")
plt.ylabel('True label')
plt.xlabel('Predicted label')
plt.show();