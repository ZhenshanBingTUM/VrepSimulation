# -*- coding: utf-8 -*-
"""
Created on Fri Mar 17 19:30:43 2017

@author: bing
"""

# import modules
import vrep     # V-rep library
import sys
import time
import numpy as np
import matplotlib.pyplot as plt

vrep.simxFinish(-1) # just in case, close all opened connections

clientID = vrep.simxStart('127.0.0.1', 19997, True, True, 5000, 5)
if clientID!=-1:   #check if client connection successful
    print 'Connected to remote API server'
    
else:
    print 'Connection not successful'
    sys.exit('Could not connect')
    
# start time t
t = time.time()
    
# main loop
while (time.time() - t) < 5:
    print 'Time is:', time.time()


print 'Simulation finished'