# -*- coding: utf-8 -*-
"""
Created on Mon Apr 12 15:59:40 2021

@author: hsbbd
"""


import numpy as np
import pandas as pd
import os.path
from os import path


filePath ='C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined_1.csv'
data = pd.read_csv(filePath, header=0)
d = [" ","run",	"activity",	"time",	"id","RSSI","phase"]
cleaned_df = pd.DataFrame(columns=d)
i = 0
j=0
while i<len(data):
    if i == 0:
        cleaned_df.loc[j] = data.loc[i]
        # cleaned_df["activity"][j] = data["activity"][i]
        # cleaned_df["time"][j] = data["time"][i]
        # cleaned_df["RSSI"][j] = data["RSSI"][i]
        # cleaned_df["phase"][j] = data["phase"][i]
        i+=1
        j+=1
    else:
        lastTime = data["time"][i-1]
        lastTag = data["id"][i-1]
        lastRSSI = data["RSSI"][i-1]
        if lastTime == data["time"][i] and lastTag == data["id"][i] and lastRSSI == data["RSSI"][i]:
            print("same")
        else:
            cleaned_df.loc[j] = data.loc[i]
            # cleaned_df["run"][j] = data["run"][i]
            # cleaned_df["activity"][j] = data["activity"][i]
            # cleaned_df["time"][j] = data["time"][i]
            # cleaned_df["RSSI"][j] = data["RSSI"][i]
            # cleaned_df["phase"][j] = data["phase"][i]
            j+=1
        i+=1

print(cleaned_df)
cleaned_df["activity"].plot.hist()
cleaned_df.to_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/combined_1_noduplicates.csv')  
# print(data.iloc[0])
# print(len(data))


