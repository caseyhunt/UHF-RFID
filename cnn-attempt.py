# -*- coding: utf-8 -*-
"""
Created on Mon Apr 12 10:11:49 2021

@author: hsbbd
"""

import pandas as pd
import numpy as np
from scipy import stats
from sklearn import metrics
from sklearn.model_selection import train_test_split



# cnn model
from numpy import mean
from numpy import std
from numpy import dstack
from pandas import read_csv
from matplotlib import pyplot
from keras.models import Sequential
from keras.layers import Dense
from keras.layers import Flatten
from keras.layers import Dropout
from keras.layers.convolutional import Conv1D
from keras.layers.convolutional import MaxPooling1D
from keras.utils import to_categorical

data = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined.csv', header=0)

n_time_steps = 200
n_features = 2
step = 10
segments = []
labels = []
RANDOM_SEED = 42
RSSI_train = []
RSSI_test =[]
phase_train =[] 
phase_test =[]


for i in range(0, len(data) - n_time_steps, step):
    RSSI = data['RSSI'].values[i: i + n_time_steps] 
   # phase = data['phase'].values[i: i + n_time_steps]
    phase= data['id'].values[i: i + n_time_steps]
    label = stats.mode(data['activity'][i: i + n_time_steps])[0][0]
    #label = data['activity'][i]
    segments.append([phase,RSSI])
    labels.append(label)

print(np.array(segments).shape)


reshaped_segments = np.asarray(segments).reshape(-1, n_time_steps, n_features)
labels = np.asarray(pd.get_dummies(labels))

print(np.array(reshaped_segments).shape)


RSSI_train, RSSI_test, phase_train, phase_test = train_test_split(
        reshaped_segments, labels, test_size=0.2, random_state=RANDOM_SEED)

n_time_steps, n_features, n_outputs = RSSI_train.shape[1], RSSI_train.shape[2], phase_train.shape[1]

def load_dataset(prefix=''):
    return RSSI_train, RSSI_test, phase_train, phase_test

# fit and evaluate a model
def evaluate_model(RSSI_train, phase_train, RSSI_test, phase_test):
	verbose, epochs, batch_size = 0, 10, 32
	n_timesteps, n_features, n_outputs = RSSI_train.shape[1], RSSI_train.shape[2], phase_train.shape[1]
	model = Sequential()
	model.add(Conv1D(filters=64, kernel_size=3, activation='relu', input_shape=(n_timesteps,n_features)))
	model.add(Conv1D(filters=64, kernel_size=3, activation='relu'))
	model.add(Dropout(0.5))
	model.add(MaxPooling1D(pool_size=2))
	model.add(Flatten())
	model.add(Dense(100, activation='relu'))
	model.add(Dense(n_outputs, activation='softmax'))
	model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
	# fit network
	model.fit(RSSI_train, phase_train, epochs=epochs, batch_size=batch_size, verbose=verbose)
	# evaluate model
	_, accuracy = model.evaluate(RSSI_test, phase_test, batch_size=batch_size, verbose=0)
	return accuracy
 
# summarize scores
def summarize_results(scores):
	print(scores)
	m, s = mean(scores), std(scores)
	print('Accuracy: %.3f%% (+/-%.3f)' % (m, s))
 
# run an experiment
def run_experiment(repeats=10):
    RSSI_train, RSSI_test, phase_train, phase_test = load_dataset()
	# repeat experiment
    scores = list()
    for r in range(repeats):
        score = evaluate_model(RSSI_train, phase_train, RSSI_test, phase_test )
        score = score * 100.0
        print('>#%d: %.3f' % (r+1, score))
        scores.append(score)
	# summarize results
    summarize_results(scores)
 
# run the experiment
run_experiment()