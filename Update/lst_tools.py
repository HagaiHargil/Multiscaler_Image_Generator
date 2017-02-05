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


def allocate_photons(df=None, gui=None) -> pd.DataFrame:
    """
    Returns a dataframe in which each photon is a part of a frame, line and possibly laser pulse
    :param df: All events data
    :return: pandas.DataFrame
    """
    import numpy as np

    if df.shape[0] == 0:
        raise ValueError('Received dataframe was empty.')

    df_photons = df[df['channel'] == '001'].reset_index(drop=True)
    df_lines = df[df['channel'] == '010'].reset_index(drop=True)
    help_dict = {
        gui.input_start.get(): '110',
        gui.input_stop1.get(): '001',
        gui.input_stop2.get(): '010'
        }
    if 'Laser' in help_dict.keys():
        df_first_index = df[df['channel'] == help_dict['Laser']].reset_index(drop=True)
    else:
        df_first_index = df[df['channel'] == help_dict['Frames']].reset_index(drop=True)

    indices_photons_in_lines = np.searchsorted(df_lines['abs_time'], df_photons['abs_time']) - 1
    indices_photons_in_first_index = np.searchsorted(df_first_index['abs_time'], df_photons['abs_time']) - 1

    df_photons['photon_line_time'] = df_lines.loc[indices_photons_in_lines, 'abs_time'].values
    df_photons['photon_first_index_time'] = df_first_index.loc[indices_photons_in_first_index, 'abs_time'].values
    df_photons.dropna(axis=0, how='any', inplace=True)

    # Define relative times
    df_photons['time_rel_line'] = df_photons['abs_time'] - df_photons['photon_line_time']
    df_photons['time_rel_first_index'] = df_photons['abs_time'] - df_photons['photon_first_index_time']

    last_event_time = int(df_photons['abs_time'].max())
    df_photons['photon_line_time'] = df_photons['photon_line_time'].astype('category')
    df_photons['photon_first_index_time'] = df_photons['photon_first_index_time'].astype('category')

    assert df_photons['time_rel_line'].any() > 0
    assert df_photons['time_rel_first_index'].any() > 0

    if df_first_index.shape[0] > df_lines.shape[0]:  # First index is laser pulses, we need to create frames
        frame_array = create_frame_array(last_event_time=last_event_time, gui=gui)
        indices_photons_in_frames = np.searchsorted(frame_array, df_photons['abs_time']) - 1
        df_photons['photon_frame_time'] = frame_array[indices_photons_in_frames, 'abs_time'].values
        df_photons['time_rel_frame'] = df_photons['abs_time'] - df_photons['photon_frame_time']

        df_photons.drop(['abs_time'], axis=1, inplace=True)
        df_photons.set_index(keys=['photon_frame_time', 'photon_line_time', 'photon_first_index_time'], inplace=True)
    else:
        df_photons.drop(['abs_time'], axis=1, inplace=True)
        df_photons.set_index(keys=['photon_first_index_time', 'photon_line_time'], inplace=True)



    return df_photons
