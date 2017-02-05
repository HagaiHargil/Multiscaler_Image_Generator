"""
__author__ = Hagai Hargil
"""

import attr
import matplotlib.pyplot as plt
import numpy as np


def validate_number_larger_than_zero(instance, attribute, value: int=0):
    """
    Validator for attrs module - makes sure line numbers and row numbers are larger than 0.
    """

    if value >= instance.attribute:
        raise ValueError("{} has to be larger than 0.".format(attribute))


@attr.s(slots=True)  # slots should speed up display
class Frame(object):
    """
    Contains all data and properties of a single frame of the resulting movie.
    """
    num_of_lines = attr.ib(validator=attr.validators.instance_of(int))
    num_of_rows = attr.ib(validator=attr.validators.instance_of(int))
    number = attr.ib(validator=attr.validators.instance_of(int))  # the frames' ordinal number
    data = attr.ib()
    __first_line_time = attr.ib()
    __last_line_time = attr.ib()
    __first_event_time = attr.ib()
    __max_delta_of_lines = attr.ib()
    reprate = attr.ib()  # laser repetition rate, relevant for FLIM

    @property
    def __first_line_time(self):
        return self.data.index[0][1]

    @property
    def __last_line_time(self):
        cur_max_line = self.data.index[-1][1]
        return cur_max_line + self.__max_delta_of_lines  # Last edge of the histogram doesn't exist in the dataset

    @property
    def __first_event_time(self):
        return 0

    @property
    def __max_delta_of_lines(self):
        indices, _ = zip(*self.data.index.values)  # Indices of all columns
        unique_indices = np.unique(indices)
        max_delta = np.diff(unique_indices).max()
        return max_delta

    def __create_hist_edges(self):
        """
        Create two vectors that will create the grid of the frame.
        :return: Tuple of np.array
        """

        line_edge = np.linspace(start=self.__first_line_time,
                                stop=self.__last_line_time,
                                num=self.num_of_lines)
        row_edge = np.linspace(start=self.__first_event_time,
                               stop=self.__max_delta_of_lines,
                               num=self.num_of_rows)
        return line_edge, row_edge

    def __create_hist(self) -> np.ndarray:
        """
        Create the histogram of data using calculated edges.
        :return: np.ndarray of shape [num_of_lines, num_of_rows] with the histogram data
        """

        xedges, yedges = self.__create_hist_edges()
        hist = np.histogram2d(self.data.index.get_level_values(1) + self.data["time_rel_line"],
                              self.data["time_rel_line"], bins=(xedges, yedges))

        return hist, xedges, yedges

    def display(self):
        """
        Display a single frame by creating it as an histogram.
        """

        fig = plt.figure()
        ax = fig.add_subplot(111, aspect="equal")
        ######
        self.data.to_hdf('Trial2.h5', 'Trial', format='table')
        ######
        hist_to_display, xedges, yedges = self.__create_hist()
        x, y = np.meshgrid(xedges, yedges)
        ax.pcolormesh(x, y, hist_to_display)
