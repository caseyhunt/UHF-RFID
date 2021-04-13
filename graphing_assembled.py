# -*- coding: utf-8 -*-
"""
Created on Mon Apr 12 10:48:32 2021

@author: hsbbd
"""

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
    x1,x2,x3,x4,y1,y2,y3,y4 = [], [], [],[],[],[] ,[] ,[]
    data1 = pd.read_csv('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21/runData.csv', header=0)
    x5 = data1["time"]
    y5 = data1["RSSI"]
    # fig2, ay = plt.subplots(1,sharex=True, sharey=True)
    # ay.plot(x5, y5)
    
    
    plt.plot(x5,y5) # plotting t, a separately 

    path ='C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21/'
    dataPath = path + str(i) +'.csv'
    
    
    #data = np.genfromtxt('C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/transition_tracking/salutation_02APR21_1/runData.csv', delimiter=",")
    
    data = pd.read_csv(dataPath, header=0)
    

    
    # fig, ax = plt.subplots(4,sharex=True, sharey=True)
    
    # ax[1].set_ylim(-70, -30)
    
    
    

    dataType = "RSSI"
    #print(data)
    
    grouped = data.groupby("id")
    if len(data[data["id"]=="e2001d8712401320d4a0"].index.values)>0:
        a0 = grouped.get_group("e2001d8712401320d4a0")
        x1 = float(a0["time"])
        y1 = a0[dataType]
    
    if len(data[data["id"]=="e2001d8712461320db93"].index.values)>0:
        b93 = grouped.get_group("e2001d8712461320db93")
        x2 = float(b93["time"])
        y2 = b93[dataType]
        
    if len(data[data["id"]=="e2001d8712171320c120"].index.values)>0:  
        c120 = grouped.get_group("e2001d8712171320c120")
        x3 = c120["time"]
        y3 = c120[dataType]
        
    if len(data[data["id"]=="e2001d871271320b9f"].index.values)>0: 
        b9f = grouped.get_group("e2001d871271320b9f")
        x4 = float(b9f["time"])
        y4 = b9f[dataType]
        
        
   
    plt.plot(x1,y1) # plotting t, b separately 
    plt.plot(x2,y2) # plotting t, c separately 
    plt.plot(x3,y3)
    plt.plot(x4,y4)
    plt.figure(figsize=(10,3),dpi=500)
    #plt.savefig("C:/Users/hsbbd/OneDrive/Documents/GitHub/UHF-RFID/combined plots/run 7/"+str(i)+"_"+str(dataType)+'.png')

    plt.show()
    i+=1
    print(i) 
        
        
#     if x1 is None:
#         print("no data for tag 1")
#     else:
#         ax[0].plot(x1,y1)
#     if x2 is None:  
#         print('no data for tag 2')
#     else:
#         ax[1].plot(x2,y2)
#     if x3 is None:
#         print("no data for tag 3")
#     else:
#         ax[2].plot(x3,y3)
#     if x4 is None:
#         print("no data for tag 4")
#     else:
#         ax[3].plot(x4,y4)
    
#     print("chart for activity " + str(i))
#     fig.savefig(path+str(i)+"_"+str(dataType)+'.png')
    
#     i+=1
#     #print(grouped.mean())
#     #print(a0)
    
#     # a0.plot()
#     # b93.plot()
#     # c120.plot()
#     # b9f.plot()


