# -*- coding: utf-8 -*-
"""
Created on Fri Mar 26 11:59:00 2021

@author: hsbbd
"""
from pynput.mouse import Listener
import serial
import numpy as np
import pandas as pd
import sys
import pygame
# ser = serial.Serial('COM5', 115200)

pygame.init()

# def on_move(x, y):
#     print('Pointer moved to {0}'.format(
#         (x, y)))

global reading
reading = True

global recording
recording = False




while True:
    if pygame.mouse.get_pressed(num_buttons=3) == (1,0,0):
        print("pressed")

# def on_click(x, y, button, pressed):
#     global reading
#     global recording
    
#     if pressed:
#         print("pressed")
      
         
#     if pressed and recording == True:
#          print("recording stopped")
#          reading = False
#          return False
#          #sys.exit()
#     elif pressed and recording == False:
#          recording = True
#          #reading = True
#          print("recording started")
         
    
# with Listener(
#         #on_move=on_move,
#         on_click=on_click
#       ) as listener:
#     listener.join()
    




def your_function():
    print("Hello, World")
      
        

    # data_raw = ser.readline()
    # print(data_raw)

    #    Collect events until released

    
    # ...or, in a non-blocking fashion:
# listener = mouse.Listener(
#     on_click=on_click)
# listener.start()


    



       
      
        
    # print('{0} at {1}'.format(
    #     'Pressed' if pressed else 'Released',
    #     (x, y)))
    # if not pressed:
    #     # Stop listener
    #     return False


# def on_scroll(x, y, dx, dy):
#     print('Scrolled {0} at {1}'.format(
#         'down' if dy < 0 else 'up',
#         (x, y)))

