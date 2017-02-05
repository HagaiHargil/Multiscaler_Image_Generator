# -*- coding: utf-8 -*-
"""
Created on Thu Oct 13 09:37:02 2016

@author: Hagai
"""
from gui import GUIApp
from gui import verify_gui_input


def main_data_readout(gui):
    """
    Main function that reads the lst file and processes its data.
    """
    from Update import lst_tools
    from Update import class_defs

    # Open file and find the needed parameters
    data_range = lst_tools.get_range(gui.filename.get())
    timepatch = lst_tools.get_timepatch(gui.filename.get())
    start_of_data_pos = lst_tools.get_start_pos(gui.filename.get())
    
    # Read the file into a variable
    df = lst_tools.read_lst_file(filename=gui.filename.get(), start_of_data_pos=start_of_data_pos)

    # Create a dataframe with all needed columns
    df_after_timepatch = lst_tools.timepatch_sort(df=df, timepatch=timepatch, data_range=data_range)

    # Allocate photons to their frame and lines
    df_allocated = lst_tools.allocate_photons(df=df_after_timepatch, gui=gui)

    # Create a single frame object

    num_of_lines = 512
    num_of_rows = 512
    frame_ordinal_number = 1
    reprate = 80e6  # 80 MHz laser

    #frame1 = class_defs.Frame(data=df_allocated, num_of_lines=num_of_lines, num_of_rows=num_of_rows,
    #                          number=frame_ordinal_number, reprate=reprate)

    #frame1.display()

    return df_allocated

if __name__ == '__main__':
    # file_name = 'PMT1_Readings_one_sweep_equals_one_frame.lst'
    # file_name = 'live mouse  100 um deep with 62p TAG001.lst'
    # file_name = 'Tilted fixed sample - TAG 190 kHz 62 percent - both galvos on - 99 percent power - 450 gain - DISCONNECTED GALVO Y.lst'
    # file_name ='multiscaler_check_code_2_channels_0-1_sec.lst'
    # file_name = 'live mouse  100 um deep with 62p TAG010.lst'
    # file_name = 'fixed sample - XY image - 500 gain - 1 second acquisition.lst'
    # file_name = 'TAG ON start channel, galvo on stop 2 - gain 480.lst'
    gui = GUIApp()
    gui.root.mainloop()
    verify_gui_input(gui)  # Still missing
    df_after = main_data_readout(gui)


