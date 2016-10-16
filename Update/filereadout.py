# -*- coding: utf-8 -*-
"""
Created on Thu Oct 06 16:24:53 2016

@author: Hagai
"""
import time
import numpy as np
import pandas as pd
import vectorizeData as vecData

fileName = 'C:\Users\Hagai\Documents\GitHub\Multiscaler_Image_Generator\Update\PMT1_Readings_one_sweep_equals_one_frame.lst'

#f = open(fileName, 'r')
#f.seek(1549)
#print 'Using Pythons readlines method:'
#start = time.time()
#L = f.readlines()
#print 'It took', time.time()-start, 'seconds.'
#f.close()
#L = None


f = open(fileName, 'r')
f.seek(1553)
print 'Using Pythons splitlines method:'
start = time.time()
P = f.read()
P2 = P.splitlines()
print 'It took', time.time()-start, 'seconds.'
f.close()
P = None

df = vecData.vectorizingData(P2)
#
#f = open(fileName, 'r')
#f.seek(1553)
#print 'Using np.loadtext'
#start = time.time()
#L = np.genfromtxt(f, dtype='S', usecols = (0,))
#print 'It took', time.time()-start, 'seconds.'
#f.close()

#f = open(fileName, 'r')
#f.seek(1547)
#print 'Using pandas'
#start = time.time()
#Pa = pd.read_csv(f)
#print 'It took', time.time()-start, 'seconds.'
#Pa.columns = ['raw']
#Pa['last'] = Pa['raw'].str[-1]
#Pa['binary'] = Pa['raw'].apply(lambda x: bin(int(x, 16)))
#f.close()