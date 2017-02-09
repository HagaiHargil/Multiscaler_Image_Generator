"""
__author__ = Hagai Hargil
"""

import attr
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


def validate_number_larger_than_zero(instance, attribute, value: int=0):
    """
    Validator for attrs module - makes sure line numbers and row numbers are larger than 0.
    """

    if value >= instance.attribute:
        raise ValueError("{} has to be larger than 0.".format(attribute))


@attr.s
class Movie(object):
    """
    A holder for Frame objects to be displayed consecutively.
    """

    list_of_frame_times = attr.ib()
    data = attr.ib()
    reprate = attr.ib()
    num_of_cols = attr.ib(validator=attr.validators.instance_of(int))
    num_of_rows = attr.ib(validator=attr.validators.instance_of(int))
    list_of_frames = attr.ib(default=None)
    name = attr.ib()
    fps = attr.ib()

    @property
    def list_of_frames(self):
        """Populate the list containing the frames"""

        list_of_frames = []
        for idx, current_time in enumerate(self.list_of_frame_times):
            cur_data = self.data[self.data.index.get_level_values('Frames') == current_time]
            if not cur_data.empty:
                list_of_frames.append(Frame(data=cur_data, num_of_lines=self.num_of_cols,
                                            num_of_rows=self.num_of_rows, number=idx,
                                            reprate=self.reprate))
            else:
                list_of_frames.append(Frame(data=cur_data, num_of_lines=self.num_of_cols,
                                            num_of_rows=self.num_of_rows, number=idx,
                                            reprate=self.reprate, empty=True))
        return list_of_frames

    def play(self):
        """Create all frames, frame-by-frame and display them"""

        import matplotlib.animation as manimation

        # Create a list containing the frames before showing them
        frames = []
        single_frame = {'x': None, 'y': None, 'hist': None}
        for cur_frame in self.list_of_frames:
            single_frame['hist'], single_frame['x'], single_frame['y'] = cur_frame.create_hist()
            frames.append(single_frame)

        # Start the animation
        FFMpegWriter = manimation.writers['ffmpeg']
        metadata = dict(title=self.name, artist='Multiscaler')
        writer = FFMpegWriter(fps=1, metadata=metadata)

        fig = plt.figure()
        img = plt.imshow(np.zeros((self.num_of_rows, self.num_of_cols)), cmap='gray')

        with writer.saving(fig, "{}.mp4".format(self.name), 100):
            for frame in frames:
                img.set_data(frame['hist'])
                img.autoscale()
                img.set_data(frame['hist'])
                writer.grab_frame()


@attr.s(slots=True)  # slots should speed up display
class Frame(object):
    """
    Contains all data and properties of a single frame of the resulting movie.
    """
    num_of_lines = attr.ib()
    num_of_rows = attr.ib()
    number = attr.ib(validator=attr.validators.instance_of(int))  # the frame's ordinal number
    data = attr.ib()
    __metadata = attr.ib()
    reprate = attr.ib()  # laser repetition rate, relevant for FLIM
    empty = attr.ib(default=False)

    @property
    def __metadata(self) -> pd.DataFrame:
        """
        Creates the metadata of the frames to be created, to be used for creating the actual images
        using histograms. Metadata can include the first photon arrival time, start and end of frames, etc.
        :return: pd.DataFrame of all needed metadata.
        """
        index_list = ['First', 'Last', 'MaxDelta']
        index_table = pd.DataFrame(columns=self.data.index.names, index=index_list)
        index_table.loc['First', :] = self.data.index.min()

        for col in index_table:
            unique_indices = np.unique(self.data.index.get_level_values(col))
            if len(unique_indices) > 1:
                index_table.loc['MaxDelta', col] = np.diff(unique_indices).max()
            else:
                index_table.loc['MaxDelta', col] = 0

        index_table.loc['Last', :] = self.data.index.max() + index_table.loc['MaxDelta', :]

        # Mandatory values and check-ups
        index_table.loc['First', 'Lines'] = 0  # a line always starts from time 0
        try:  # checking if we have laser input for FLIM
            index_table.loc['MaxDelta', 'Laser'] = 1/self.reprate
        except KeyError:
            pass

        if index_table.loc['Last', 'Frames'] == 0:  # single frame of data
            index_table.loc['Last', 'Frames'] = index_table.loc['Last', 'Lines']

        return index_table

    def __create_hist_edges(self):
        """
        Create two vectors that will create the grid of the frame.
        :return: Tuple of np.array
        """

        col_edge = np.linspace(start=self.__metadata.loc['First', 'Lines'],
                                stop=self.__metadata.loc['MaxDelta', 'Lines'],
                                num=self.num_of_lines)
        row_edge = np.linspace(start=self.__metadata.loc['First', 'Frames'],
                               stop=self.__metadata.loc['Last', 'Frames'],
                               num=self.num_of_rows)

        assert np.all(np.diff(col_edge) > 0)
        assert np.all(np.diff(row_edge) > 0)

        return col_edge, row_edge

    def create_hist(self):
        """
        Create the histogram of data using calculated edges.
        :return: np.ndarray of shape [num_of_cols, num_of_rows] with the histogram data, and edges
        """
        if not self.empty:
            xedges, yedges = self.__create_hist_edges()
            col_data_as_series = self.data["time_rel_line"]
            col_data_as_array = np.array(col_data_as_series)
            row_data_as_series = self.data.index.get_level_values('Frames').codes + self.data["time_rel_frames"]
            row_data_as_array = np.array(row_data_as_series)

            hist, x, y = np.histogram2d(col_data_as_array, row_data_as_array, bins=(xedges, yedges))
        else:
            return np.zeros(self.num_of_lines, self.num_of_rows), 0, 0

        return hist, x, y
