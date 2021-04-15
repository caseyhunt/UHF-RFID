# -*- coding: utf-8 -*-
"""
Created on Tue Apr 13 12:34:17 2021

@author: hsbbd
"""

##i used a random number generator with the runs to determine I wanted to use run 7. 


import pandas as pd

data = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined_noduplicates_no3.csv', header=0)
training = pd.DataFrame()
testing =pd.DataFrame()
i = 0

print(data.head())



while i<len(data):
    if data.loc[i] is None:
        print("none")
    else:
        if data["run"][i] == 7:
            if testing is None:
                testing = data.loc[i]
            else:
                testing = testing.append(data.loc[i])
        else:
            if training is None:
                training = data.loc[i]
            else:
                training = training.append(data.loc[i])
  
    i+=1
    
testing.to_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/testing.csv')  
training.to_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/training.csv')  