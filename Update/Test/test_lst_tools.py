import unittest


class TddLstTools(unittest.TestCase):
    """
    Tests for new multiscaler readout functions
    """
    list_of_file_names = [r'..\PMT1_Readings_one_sweep_equals_one_frame.lst',
                          r'..\Tilted fixed sample - TAG 190 kHz 62 percent - both galvos on - 99 percent power - 450 gain - DISCONNECTED GALVO Y.lst',
                          r'..\live mouse  100 um deep with 62p TAG001.lst',
                          r'..\multiscaler_check_code_2_channels_0-1_sec.lst',
                          r'..\live mouse  100 um deep with 62p TAG010.lst',
                          r'..\fixed sample - XY image - 500 gain - 1 second acquisition.lst',
                          r'..\TAG ON start channel, galvo on stop 2 - gain 480.lst']

    list_of_real_start_loc = [1548, 1549, 1549, 1553, 1553, 1749, 1486]

    def test_check_range_extraction(self):
        from Update.lst_tools import get_range

        list_of_real_range = [1232704 * 2 ** 9, 4065600 * 2 ** 8, 8388608 * 2 ** 10, 50009600 * 2 ** 3,
                              8589934592, 80000000 * 2 ** 4, 8388608 * 2 ** 11]

        list_of_returned_range = []
        for fname in self.list_of_file_names:
            list_of_returned_range.append(get_range(fname))

        self.assertEqual(list_of_real_range, list_of_returned_range)

    def test_check_time_patch_extractions(self):
        from Update.lst_tools import get_timepatch

        list_of_real_time_patch = ['32', '32', '32', '32', '32', '32', '2']

        list_of_returned_time_patch = []
        for fname in self.list_of_file_names:
            list_of_returned_time_patch.append(get_timepatch(fname))

        self.assertEqual(list_of_real_time_patch, list_of_returned_time_patch)

    def test_check_start_of_data_value(self):
        from Update.lst_tools import get_start_pos

        list_of_returned_locs = []
        for fname in self.list_of_file_names:
            list_of_returned_locs.append(get_start_pos(fname))

        self.assertEqual(self.list_of_real_start_loc, list_of_returned_locs)

    def test_first_line_of_input(self):
        from Update.lst_tools import read_lst_file

        list_of_first_event = ['010000002759', '01000000c659', '010000000159', '0100000002e6', '0100000006d9',
                               '0100000060d9', '0000000196a6']
        list_of_returned_events = []

        for idx, fname in enumerate(self.list_of_file_names):
            first_event = read_lst_file(fname, self.list_of_real_start_loc[idx])['raw'][0]
            list_of_returned_events.append(first_event)

        self.assertEqual(list_of_first_event, list_of_returned_events)

if __name__ == '__main__':
    unittest.main()
