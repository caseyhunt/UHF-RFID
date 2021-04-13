# -*- coding: utf-8 -*-
"""
Created on Sat Apr 10 19:49:07 2021

@author: hsbbd
"""

import numpy as np
import pandas as pd
import os.path
from os import path

combined = pd.DataFrame()


j = 0

while j<11:
    
    if j==0:
        filePath ='C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21/'
    else:
        filePath = 'C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21_'
        filePath = filePath + str(j) + "/"
    i=1
    while i<12:
        dataPath = filePath + str(i) +'.csv'
        if path.exists(dataPath):    
            data = pd.read_csv(dataPath, header=0)
            data.insert(0, "activity", i, True)
            data.insert(0, "run", j, True)
            combined = combined.append(data)
            #print(data)
        i+=1
        
    j+=1

combined.to_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined.csv')  

#combined['activity'].value_counts().plot(kind='bar', title='Training examples by activity type');
