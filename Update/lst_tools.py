import pandas as pd
import numpy as np

def hex_to_bin_dict():
    """
    Create a simple dictionary that maps a hex input into a 4 letter binary output.
    :return: dict
    """
    diction = \
        {
            '0': '0000',
            '1': '0001',
            '2': '0010',
            '3': '0011',
            '4': '0100',
            '5': '0101',
            '6': '0110',
            '7': '0111',
            '8': '1000',
            '9': '1001',
            'a': '1010',
            'b': '1011',
            'c': '1100',
            'd': '1101',
            'e': '1110',
            'f': '1111',
        }
    return diction

def create_data_length_dict():
    """
    CURRENTLY DEPRECATED
    :return:
    """
    dict_of_data_length = \
        {
            "0": 16,
            "5": 32,
            "1": 32,
            "1a": 44,
            "2a": 48,
            "22": 48,
            "32": 48,
            "2": 48,
            "5b": 64,
            "Db": 64,
            "f3": 64,
            "43": 64,
            "c3": 64,
            "3": 64
        }
    return dict_of_data_length

def get_range(filename: str = '') -> int:
    """
    Finds the "range" of the current file in the proper units
    :return: range as defined my MCS, after bit depth multiplication
    """
    import re

    if filename == '':
        raise ValueError('No filename given.')

    format_range = re.compile(r'range=(\d+)')
    with open(filename, 'r') as f:
        cur_str = f.read(500)  # read 100 chars for the basic values

    range_before_bit_depth = int(re.search(format_range, cur_str).group(1))
    format_bit_depth = re.compile(r'bitshift=(\w+)')
    bit_depth_wrong_base = re.search(format_bit_depth, cur_str).group(1)
    bit_depth_as_hex = bit_depth_wrong_base[-2:]  # last 2 numbers count
    range_after_bit_depth = range_before_bit_depth * 2 ** int(bit_depth_as_hex, 16)

    assert isinstance(range_after_bit_depth, int)
    return range_after_bit_depth


def get_timepatch(filename: str = '') -> str:
    """
    Get the time patch value out of of a list file.
    :param filename: File to be read.
    :return: Time patch value as string.
    """
    import re

    if filename == '':
        raise ValueError('No filename given.')

    format_timepatch = re.compile(r'time_patch=(\w+)')
    with open(filename, 'r') as f:
        cur_str = f.read(5000)  # read 5000 chars for the timepatch value

    timepatch = re.search(format_timepatch, cur_str).group(1)
    # data_length_dict = create_data_length_dict()
    # data_length = data_length_dict[timepatch]

    assert isinstance(timepatch, str)
    # assert isinstance(data_length, int)
    # return timepatch, data_length - DEPRECATED
    return timepatch


def get_start_pos(filename: str = '') -> int:
    """
    Returns the start position of the data
    :param filename: Name of file
    :return: Integer of file position for f.seek() method
    """
    import re

    if filename == '':
        raise ValueError('No filename given.')

    format_data = re.compile(r"DATA]\n")
    pos_in_file = 0
    with open(filename, 'r') as f:
        while pos_in_file == 0:
            line = f.readline()
            match = re.search(format_data, line)
            if match is not None:
                pos_in_file = f.tell()
                return pos_in_file  # to have the [DATA] as header


def read_lst_file(filename: str = '', start_of_data_pos: int = 0) -> pd.DataFrame:
    """
    Read the list file into a dataframe.
    :param filename: Name of list file.
    :param start_of_data_pos: The place in chars in the file that the data starts at.
    :param data_length: A dictionary with the data length in binary as int
    :return: Dataframe with all events registered.
    """
    import pandas as pd
    #### TRIAL VERSION, DEPRECATED. TRY TO RAISE FROM DEAD ONLY IF CURRENT VERSION IS SLOW ###############
    # def binarize(str1):
    #     return "{0:0{1}b}".format(int(str1, 16), data_length)
    #
    # with open(filename, 'r') as f:
    #     dict_bin = dict([('bin', binarize)])
    #     f.seek(start_of_data_pos)
    #     df = pd.read_csv(f, header=0, converters=dict_bin, dtype=str, names=['bin'])
    ######################################################################################################

    if filename is '' or start_of_data_pos == 0:
        return ValueError('Wrong input detected.')

    with open(filename, 'r') as f:
        f.seek(start_of_data_pos)
        file_as_one_block = f.read()
        file_separated = file_as_one_block.splitlines()  # was found to be the fastest Python method

    df = pd.DataFrame(file_separated, columns=['raw'])

    assert df.shape[0] > 0
    return df

def timepatch_sort(df, timepatch: str = '', data_range: int = 0) -> pd.DataFrame:
    """
    Takes a raw dataframe and sorts it to columns according to its timepatch value.
    :param df: Input DF.
    :param timepatch: Key by which we sort.
    :param data_range: Data range of file.
    """
    from Update import timepatch_manager

    # Verify inputs
    if df.shape[0] == 0 or timepatch == '' or data_range == 0:
        raise ValueError("Wrong inputs inserted.")

    # Create dictionary for hex to bin conversion
    hex_to_bin = hex_to_bin_dict()

    # %% Analyze channel and edge information
    df['bin'] = df['raw'].str[-1].map(hex_to_bin)
    df['channel'] = df['bin'].str[-3:].astype(dtype='category')
    df['edge'] = df['bin'].str[-4].astype(dtype='category')
    df.drop(['bin'], axis=1, inplace=True)

    # %% Start going through the dataFormat vector and extract the bits
    df_after_timepatch = timepatch_manager.ChoiceManager().process(timepatch, data_range, df)
    df_after_timepatch.drop(['raw'], axis=1, inplace=True)
    if list(df_after_timepatch.columns) != ['channel', 'edge', 'abs_time', 'sweep', 'tag', 'lost']:
        raise ValueError('Wrong dataframe created.')

    return df_after_timepatch

def create_frame_array(last_event_time: int=None, gui=None) -> np.ndarray:
    """Create a pandas Series of start-of-frame times"""
    if (last_event_time == None) or (gui == None):
        raise ValueError('Wrong input detected.')

    array_of_frames = np.linspace(start=0, stop=last_event_time, num=int(gui.num_of_frames.get()), endpoint=False)
    return array_of_frames

def create_line_array(last_event_time: int=None, gui=None) -> np.ndarray:
    """Create a pandas Series of start-of-line times"""
    if (last_event_time == None) or (gui == None):
        raise ValueError('Wrong input detected.')

    num_of_lines = 512  # NEEDS TO CHANGE SOMEDAY
    total_lines = num_of_lines * int(gui.num_of_frames.get())
    line_array = np.linspace(start=0, stop=last_event_time, num=total_lines)
    return line_array

def determine_data_channels(df: pd.DataFrame=None, gui=None):
    """Create a dictionary that contains the data in its ordered form."""

    if df.empty:
        raise ValueError('Received dataframe was empty.')

    dict_of_inputs = {
        gui.input_start.get(): '110',
        gui.input_stop1.get(): '001',
        gui.input_stop2.get(): '010'
        }

    dict_of_data = {}
    for key in dict_of_inputs:
        if key != 'Empty':
            dict_of_data[key] = df.loc[df['channel'] == dict_of_inputs[key], 'abs_time'].reset_index(drop=True)

    if 'Frames' not in dict_of_data.keys():  # A 'Frames' channel has to exist to create frames
        last_event_time = int(dict_of_data['PMT1'].max())  # Assuming only data from PMT1 is relevant here
        frame_array = create_frame_array(last_event_time=last_event_time, gui=gui)
        dict_of_data['Frames'] = pd.Series(frame_array, name='abs_time')

    if 'Lines' not in dict_of_data.keys():  # A 'Lines' channel has to exist to create frames
        last_event_time = dict_of_data['PMT1'].max()  # Assuming only data from PMT1 is relevant here
        line_array = create_line_array(last_event_time=last_event_time, gui=gui)
        dict_of_data['Lines'] = pd.Series(line_array, name='abs_time')

    assert {'PMT1', 'Lines', 'Frames'} <= set(dict_of_data.keys())  # A is subset of B
    return dict_of_data

def allocate_photons(dict_of_data=None, gui=None) -> pd.DataFrame:
    """
    Returns a dataframe in which each photon is a part of a frame, line and possibly laser pulse
    :param dict_of_data: All events data, distributed to its input channel
    :return: pandas.DataFrame
    """
    import numpy as np

    # Preparations
    irrelevant_keys = {'PMT1', 'PMT2'}
    relevant_keys = set(dict_of_data.keys()) - irrelevant_keys

    df_photons = dict_of_data['PMT1']
    df_photons = pd.DataFrame(df_photons)  # before this change it's a series with a name, not column head
    column_heads = {'Lines': 'time_rel_line', 'Frames': 'time_rel_frames',
                    'Laser': 'time_rel_pulse', 'TAG Lens': 'time_rel_tag'}

    # Main loop - Sort lines and frames for all photons and calculate relative time
    for key in relevant_keys:
        sorted_indices = dict_of_data[key].searchsorted(dict_of_data['PMT1']) - 1
        df_photons[key] = dict_of_data[key].loc[sorted_indices].values.copy()
        df_photons[column_heads[key]] = df_photons['abs_time'] - df_photons[key]  # relative time of each photon in
        #                                                                       accordance to the line\frame\laser pulse
        assert df_photons[key].any() >= 0
        df_photons[key] = df_photons[key].astype('category')
        df_photons.set_index(keys=key, inplace=True, append=True, drop=True)

    # Closure
    df_photons.dropna(axis=0, how='any', inplace=True)  # NaNs are the result of photons not allocated to
    #                                                     a 'secondary' signal, like a line or laser pulse
    df_photons.drop(['abs_time'], axis=1, inplace=True)

    return df_photons
