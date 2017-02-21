"""
__author__ = Hagai Hargil
"""
from typing import Dict
import _pickle as pickle
import json


def create_dict(num_of_bits: int = 0):
    """
    Creates the look-up dictionary to be used when converting events from the multiscaler into integer values.
    :param num_of_bits: The number of total bits that can be present in the event.
    :return: Large dictionary.
    """
    import shelve

    batch_size = 1e4
    if num_of_bits <= 0:
        raise ValueError('Wrong input detected (has to be greater than 0.')

    if not isinstance(num_of_bits, int):
        raise TypeError('Number of bytes needs to be a string.')

    cur_num = 0
    hex_dict = {}

    with shelve.open('{}'.format(num_of_bits), 'c') as fp:
        while cur_num < 2 ** num_of_bits:
            for idx in range(batch_size):
                hex_dict[bin(cur_num)[2:].zfill(num_of_bits)] = cur_num
            fp[bin(cur_num)[2:].zfill(num_of_bits)] = cur_num
            # pickle.dump(hex_dict, fp)
            # hex_dict = {}
            cur_num += 1

def save_dic_to_pickle(dic_to_save: Dict, filename: str = ''):
    """
    Takes the dictionary created in create_dict and saves it to a file.
    :param dic_to_save: Dictionary to be saved.
    :param filename:
    :return:
    """
    if not isinstance(filename, str):
        raise TypeError('filename parameter has to be a string.')


def read_dic_from_pickle(filename: str) -> Dict:
    import ast
    import shelve
    if not isinstance(filename, str):
        raise TypeError('Filename has to be a string.')

    dic_from_file = {}
    with shelve.open('{}'.format(filename), 'r') as fp:
        for key in fp.keys():
            dic_from_file[key] = fp[key]
        # dic_from_file = pickle.load(fp)

        return dic_from_file


if __name__ == "__main__":
    num_of_bits = 28
    create_dict(num_of_bits)

    # save_dic_to_pickle(dic, str(num_of_bits))
    # pprint(dic)
    print('File saved successfully.')
    dic = read_dic_from_pickle(str(num_of_bits))
    print('File read successfully.')