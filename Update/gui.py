"""
__author__ = Hagai Hargil
"""
from tkinter import *
from tkinter import ttk
from tkinter import filedialog
import os

def verify_gui_input(gui):
    """Validate all GUI inputs"""
    pass

class GUIApp(object):
    """Main GUI for the multiscaler code"""
    def __init__(self):
        self.root = Tk()
        self.root.title("Multiscaler Readout and Display")
        #self.root.rowconfigure(0, weight=1)
        #self.root.columnconfigure(0, weight=1)

        # Part containing the browse for file option
        main_frame = ttk.Frame(self.root, width=800, height=800)
        main_frame.grid(column=0, row=0)
        main_frame['borderwidth'] = 2

        self.filename = StringVar()

        browse_button = ttk.Button(main_frame, text="Browse", command=self.__browsefunc)
        browse_button.grid(column=0, row=0)

        # Part containing the data about input channels
        self.input_start = StringVar()
        self.input_stop1 = StringVar()
        self.input_stop2 = StringVar()
        tuple_of_data_sources = ('PMT1', 'PMT2', 'Lines', 'Frames', 'Laser', 'TAG Lens')
        mb1 = ttk.Combobox(main_frame, textvariable=self.input_start)
        mb1.grid(column=3, row=1)
        mb1.set('Frames')
        mb1['values'] = tuple_of_data_sources
        mb2 = ttk.Combobox(main_frame, textvariable=self.input_stop1)
        mb2.grid(column=3, row=2)
        mb2.set('PMT1')
        mb2['values'] = tuple_of_data_sources
        mb3 = ttk.Combobox(main_frame, textvariable=self.input_stop2)
        mb3.grid(column=3, row=3)
        mb3.set('Lines')
        mb3['values'] = tuple_of_data_sources

        input_channel_1 = ttk.Label(text='START')
        input_channel_1.grid(column=0, row=1)
        input_channel_2 = ttk.Label(text='STOP1')
        input_channel_2.grid(column=0, row=2)
        input_channel_3 = ttk.Label(text='STOP2')
        input_channel_3.grid(column=0, row=3)

        frame_label = ttk.Label(main_frame, text='Number of frames')
        frame_label.grid(column=0, row=3)
        self.num_of_frames = StringVar()
        num_frames_entry = ttk.Entry(main_frame, textvariable=self.num_of_frames)
        num_frames_entry.grid(column=0, row=4)
        num_frames_entry.focus()

        # Define the last quit button and wrap up GUI
        quit_button = ttk.Button(self.root, text='Start', command=self.root.destroy)
        quit_button.grid()
        self.root.bind('<Return>', quit_button)
        for child in main_frame.winfo_children(): child.grid_configure(padx=2, pady=2)
        self.root.wait_window()

    def __browsefunc(self):
        self.filename.set(filedialog.askopenfilename(filetypes=[('List files', '*.lst')], title='Choose a list file'))

if __name__ == '__main__':
    app = GUIApp()

