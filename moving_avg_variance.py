# -*- coding: utf-8 -*-
"""
Created on Tue May 11 23:19:53 2021

@author: hsbbd
"""


import pandas as pd
import numpy as np
import statistics
data = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/recorder/recorder/sitting_11May21/sitting_just_ones.csv', header=0)


n_time_steps = 3
n_features = 2
step = 3
thisLabel = 1
avg = []
var = []
activity = []
time = []

for i in range(0, len(data) - n_time_steps, step):
    
    if(data['activity'][i+n_time_steps]== thisLabel):
        print(statistics.mean(data['RSSI'].values[i: i + n_time_steps]))
        
        print(statistics.variance(data['RSSI'].values[i: i + n_time_steps]))
        
        print(data['activity'][i+n_time_steps])
        activity.append(thisLabel)
        time.append(data['time'][i])
        var.append(statistics.variance(data['RSSI'].values[i: i + n_time_steps]))
        avg.append(statistics.mean(data['RSSI'].values[i: i + n_time_steps]))
    else:
        thisLabel = data['activity'][i+n_time_steps]

df = pd.DataFrame(list(zip(time, activity, avg,var)), columns =['time', 'activity', 'mean', 'variance'])
df.to_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/recorder/recorder/sitting_11May21/laying_mean_var_1.csv') 
 