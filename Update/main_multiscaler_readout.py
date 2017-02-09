# -*- coding: utf-8 -*-
"""
Created on Thu Oct 13 09:37:02 2016

@author: Hagai
"""
from gui import GUIApp
from gui import verify_gui_input
import numpy as np


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
    print('Reading file...')
    df = lst_tools.read_lst_file(filename=gui.filename.get(), start_of_data_pos=start_of_data_pos)
    print('File read. Sorting the file according to timepatch...')
    # Create a dataframe with all needed columns
    df_after_timepatch = lst_tools.timepatch_sort(df=df, timepatch=timepatch, data_range=data_range)
    print('Sorted dataframe created. Starting the allocation process...')
    # Assign the proper channels to their data and function
    dict_of_data = lst_tools.determine_data_channels(df=df_after_timepatch, gui=gui)
    print('Channels of events found. Creating relative times...')
    # Allocate photons to their frame and lines
    df_allocated = lst_tools.allocate_photons(dict_of_data=dict_of_data, gui=gui)
    print('Relative times calculated. Creating Movie object...')

    # Create a movie object
    frame_times = np.unique(df_allocated.index.get_level_values('Frames')).tolist()
    fps = 1
    movie = class_defs.Movie(data=df_allocated, num_of_cols=int(gui.x_pixels.get()),
                             num_of_rows=int(gui.y_pixels.get()), reprate=float(gui.reprate.get()),
                             list_of_frame_times=frame_times, name=gui.filename.get(), fps=fps)
    movie.play()

    return df_allocated, movie

if __name__ == '__main__':

    # root = tk.Tk()
    # gui = GUIApp(root)
    # gui.mainloop()
    gui = GUIApp()
    gui.root.mainloop()
    verify_gui_input(gui)
    df_after, movie = main_data_readout(gui)


