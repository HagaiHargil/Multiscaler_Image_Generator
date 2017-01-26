# -*- coding: utf-8 -*-
"""
Created on Thu Oct 13 09:37:02 2016

@author: Hagai
"""
def main_data_readout(filename):
    """
    Main function that reads the lst file and processes its data.
    """
    from Update import lst_tools

    # Open file and find the needed parameters
    data_range = lst_tools.get_range(filename)
    timepatch = lst_tools.get_timepatch(filename)
    start_of_data_pos = lst_tools.get_start_pos(filename)
    
    # Read the file into a variable
    df = lst_tools.read_lst_file(filename=filename, start_of_data_pos=start_of_data_pos)

    # Create a dataframe with all needed columns
    df_after_timepatch = lst_tools.timepatch_sort(df=df, timepatch=timepatch, data_range=data_range)

    # Allocate photons to their frame and lines
    df_allocated = lst_tools.allocate_photons(df=df_after_timepatch)

    return df_allocated

if __name__ == '__main__':
    # file_name = 'PMT1_Readings_one_sweep_equals_one_frame.lst'
    # file_name = 'live mouse  100 um deep with 62p TAG001.lst'
    # file_name = 'Tilted fixed sample - TAG 190 kHz 62 percent - both galvos on - 99 percent power - 450 gain - DISCONNECTED GALVO Y.lst'
    # file_name ='multiscaler_check_code_2_channels_0-1_sec.lst'
    # file_name = 'live mouse  100 um deep with 62p TAG010.lst'
    # file_name = 'fixed sample - XY image - 500 gain - 1 second acquisition.lst'
    file_name = 'TAG ON start channel, galvo on stop 2 - gain 480.lst'
    df_after = main_data_readout(file_name)


