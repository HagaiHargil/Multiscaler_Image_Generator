# -*- coding: utf-8 -*-
"""
Created on Sun Oct 16 11:59:09 2016

@author: Hagai
"""


def hextobin(h):
  return bin(int(h, 16))[2:].zfill(len(h) * 4)

class ChoiceManager:

    def __init__(self):
        self.__choice_table = \
        {
            "0" : self.timePatch_0,
            "5" : self.timePatch_5,
            "1" : self.timePatch_1,
            "1a" : self.timePatch_1a,
            "2a" : self.timePatch_2a,
            "22" : self.timePatch_22,
            "32" : self.timePatch_32,
            "2" : self.timePatch_2,
            "5b" : self.timePatch_5b,
            "Db" : self.timePatch_Db,
            "f3" : self.timePatch_f3,
            "43" : self.timePatch_43,
            "c3" : self.timePatch_c3,
            "3" : self.timePatch_3,
        }

    def timePatch_0(self, data_range, df):
        def b16(x): return int(x, 16)        
        df['abs_time'] = df['raw'].str[0:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = 0
        df['tag'] = 0
        df['lost'] = 0
        return df

    def timePatch_5(self, data_range, df):
        def b16(x): return int(x, 16)         
        df['abs_time'] = df['raw'].str[2:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = df['raw'].str[0:2]
        df['sweep'] = df['sweep'].apply(b16)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = 0
        df['lost'] = 0
        return df
        
    def timePatch_1(self, data_range, df):
        def b16(x): return int(x, 16)        
        df['abs_time'] = df['raw'].str[0:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = 0
        df['tag'] = 0
        df['lost'] = 0
        return df
        
    def timePatch_1a(self, data_range, df):
        def b16(x): return int(x, 16)         
        df['abs_time'] = df['raw'].str[4:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = df['raw'].str[0:4]
        df['sweep'] = df['sweep'].apply(b16)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = 0
        df['lost'] = 0
        return df

    def timePatch_2a(self, data_range, df):
        def b16(x): return int(x, 16)         
        df['abs_time'] = df['raw'].str[4:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = df['raw'].str[2:4]
        df['sweep'] = df['sweep'].apply(b16)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = df['raw'].str[0:2]
        df['tag'] = df['tag'].apply(b16)
        
        df['lost'] = 0
        return df
        
    def timePatch_22(self, data_range, df):
        def b16(x): return int(x, 16)         
        df['abs_time'] = df['raw'].str[2:-1]
        df['abs_time'] = df['abs_time'].apply(b16)

        df['sweep'] = 0       
        
        df['tag'] = df['raw'].str[0:2]
        df['tag'] = df['tag'].apply(b16)
        
        df['lost'] = 0
        return df
        
    def timePatch_32(self, data_range, df):
        def b16(x): return int(x, 16)
        def b22(x): return int(x, 2)

        df['abs_time'] = df['raw'].str[2:-1].apply(b16)

        df['bin'] = df['raw'].str[0:2].apply(hextobin)
        df['sweep'] = df['bin'].str[1:].apply(b22)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = 0        
        
        df['lost'] = df['bin'].str[0]
        
        df.drop(['bin'], axis=1, inplace=True)
        return df
        
    def timePatch_2(self, data_range, df):
        def b16(x): return int(x, 16)        
        df['abs_time'] = df['raw'].str[0:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = 0
        df['tag'] = 0
        df['lost'] = 0
        return df
        
    def timePatch_5b(self, data_range, df):
        def b16(x): return int(x, 16)
        def b22(x): return int(x, 2)
            
        df['abs_time'] = df['raw'].str[8:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = df['raw'].str[4:8]  
        df['sweep'] = df['sweep'].apply(b16)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['bin'] = df['raw'].str[0:4]
        df['bin'] = df['bin'].apply(hextobin)
        df['tag'] = df['bin'].str[3:18]
        df['tag'] = df['tag'].apply(b22)
        
        df['lost'] = df['bin'].str[2]
        
        df.drop(['bin'], axis = 1, inplace = True)
        return df

    def timePatch_Db(self, data_range, df):
        def b16(x): return int(x, 16)
            
        df['abs_time'] = df['raw'].str[8:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = df['raw'].str[4:8]  
        df['sweep'] = df['sweep'].apply(b16)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = df['raw'].str[0:4]
        df['tag'] = df['tag'].apply(b16)
        
        df['lost'] = 0
        return df

    def timePatch_f3(self, data_range, df):
        def b16(x): return int(x, 16)
        def b22(x): return int(x, 2)
            
        df['abs_time'] = df['raw'].str[6:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['bin'] = df['raw'].str[4:6]
        df['bin'] = df['bin'].apply(hextobin)
        df['sweep'] = df['bin'].str[3:10]
        df['sweep'] = df['sweep'].apply(b22)
        df['abs_time'] = df['abs_time'] + (df['sweep'] - 1) * data_range
        
        df['tag'] = df['raw'].str[0:4]
        df['tag'] = df['tag'].apply(b16)        
        
        df['lost'] = df['bin'].str[2]
        
        df.drop(['bin'], axis = 1, inplace = True)
        return df

    def timePatch_43(self, data_range, df):
        def b16(x): return int(x, 16)
        def b22(x): return int(x, 2)
            
        df['abs_time'] = df['raw'].str[4:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = 0        
        
        df['bin'] = df['raw'].str[0:4]
        df['bin'] = df['bin'].apply(hextobin)
        df['tag'] = df['bin'].str[3:10]
        df['tag'] = df['tag'].apply(b22)
        
        df['lost'] = df['bin'].str[2]
        
        df.drop(['bin'], axis = 1, inplace = True)
        return df
        
    def timePatch_c3(self, data_range, df):
        def b16(x): return int(x, 16)
            
        df['abs_time'] = df['raw'].str[4:-1]
        df['abs_time'] = df['abs_time'].apply(b16)
        
        df['sweep'] = 0        
        
        df['tag'] = df['raw'].str[0:4]
        df['tag'] = df['bin'].apply(b16)
        
        df['lost'] = 0
        return df
        
    def timePatch_3(self, data_range, df):
        def b16(x): return int(x, 16)
        def b22(x): return int(x, 2)

        df['bin'] = df['raw'].str[0:-1]
        df['bin'] = df['raw'].apply(hextobin)
           
        df['abs_time'] = df['bin'].str[8:62]
        df['abs_time'] = df['abs_time'].apply(b22)
        
        df['sweep'] = 0        
        
        df['tag'] = df['bin'].str[3:8]
        df['tag'] = df['tag'].apply(b22)
        
        df['lost'] = df['bin'].str[2]
        
        df.drop(['bin'], axis = 1, inplace = True)
        return df
        
    def process(self, case, data_range, df):
        df_after =  self.__choice_table[case](data_range, df)
        return df_after

