# -*- coding: utf-8 -*-
"""
Created on Thu Oct 13 09:37:02 2016

@author: Hagai
"""

import pandas as pd
import numpy as np
import math
import timepatchManager
import hexToBinDictionary

import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule


# %%
def vecData(fileName, startOfDataPos, timePatch, dataRange):   
    """
    Main function that reads the lst file and processes its data.
    It returns a dataframe object back to MATLAB.
    """
    # %% Open file and prepare dataframe
    f = open(fileName, 'r')
    f.seek(startOfDataPos)
    P = f.read()
    P2 = P.splitlines()  # was found to be the fastest Python method
    f.close()
    P = None  # delete unnecessary variable for RAM purposes
    df = pd.DataFrame(P2, columns = ['raw'])
    
    # %% Create dictionary for hex to bin conversion
    hexToBin = hexToBinDictionary.hexToBinDict()
   
    # %% Analyze channel and edge information
    df['last'] = df['raw'].str[-1:]  # last hex number represents both channel and edge 
    df['bin'] = df['last'].map(hexToBin)
    df['channel'] = df['bin'].str[1:4]
    df['edge'] = df['bin'].str[0]
    df.drop(df.columns[[1, 2]], axis = 1, inplace = True) # delete unnecessary columns
    
    # %% Start going through the dataFormat vector and extract the bits
    dfAfterTimepatch = timepatchManager.ChoiceManager().process(timePatch, dataRange, df)
            
    # %% use pyCUDA for sorting
    # Create arrays for sort
    dfPhotons = dfAfterTimepatch[dfAfterTimepatch['channel'] == '001']
    dfLines = dfAfterTimepatch[dfAfterTimepatch['channel'] == '010']
    
    # Sort
    dfPhotons['line1']
            
    # %%
    return df_afterTimepatch
    
# %%
#fileName = 'PMT1_Readings_one_sweep_equals_one_frame.lst'
#df = vecData(fileName, 1548, '32', 200)

fileName = 'Tilted fixed sample - TAG 190 kHz 62 percent - both galvos on - 99 percent power - 450 gain - DISCONNECTED GALVO Y.lst'
df = vecData(fileName, 1549, '32', 200)

    