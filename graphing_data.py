# -*- coding: utf-8 -*-
"""
Created on Sat Apr 10 12:47:41 2021

@author: hsbbd
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

i=1
while i<12:
    
    

    path ='C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_14APR21_10/'
    dataPath = path + str(i) +'.csv'
    
    
    #data = np.genfromtxt('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21_1/runData.csv', delimiter=",")
    
    data = pd.read_csv(dataPath, header=0)
    
    fig, ax = plt.subplots(4,sharex=True, sharey=True)
    ax[1].set_ylim(-70, -30)
    
    
    
    x1 = None
    x2 = None
    x3 = None
    x4 = None
    
    dataType = "RSSI"
    #print(data)
    
    grouped = data.groupby("id")
    if len(data[data["id"]=="e2001d8712401320d4a0"].index.values)>0:
        a0 = grouped.get_group("e2001d8712401320d4a0")
        x1 = a0["time"]
        y1 = a0[dataType]
    
    if len(data[data["id"]=="e2001d8712461320db93"].index.values)>0:
        b93 = grouped.get_group("e2001d8712461320db93")
        x2 = b93["time"]
        y2 = b93[dataType]
        
    if len(data[data["id"]=="e2001d8712171320c120"].index.values)>0:  
        c120 = grouped.get_group("e2001d8712171320c120")
        x3 = c120["time"]
        y3 = c120[dataType]
        
    if len(data[data["id"]=="e2001d871271320b9f"].index.values)>0: 
        b9f = grouped.get_group("e2001d871271320b9f")
        x4 = b9f["time"]
        y4 = b9f[dataType]
        
        
    if x1 is None:
        print("no data for tag 1")
    else:
        ax[0].plot(x1,y1)
    if x2 is None:  
        print('no data for tag 2')
    else:
        ax[1].plot(x2,y2)
    if x3 is None:
        print("no data for tag 3")
    else:
        ax[2].plot(x3,y3)
    if x4 is None:
        print("no data for tag 4")
    else:
        ax[3].plot(x4,y4)
    
    print("chart for activity " + str(i))
    fig.savefig(path+str(i)+"_"+str(dataType)+'.png')
    
    i+=1
    #print(grouped.mean())
    #print(a0)
    
    # a0.plot()
    # b93.plot()
    # c120.plot()
    # b9f.plot()