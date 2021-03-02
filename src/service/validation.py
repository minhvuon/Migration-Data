import numpy as np

class Validation:
    def __init__(self):
        pass

    def check_nan(self, data_frame):
        right_dframe = data_frame[data_frame['Price'] != '?']
        left_dframe = data_frame[data_frame['Price'] == '?']
        return right_dframe, left_dframe

    def check_length(self, data_frame):
        right_dframe = data_frame[data_frame['Drive-wheels'].str.len() <= 5]
        left_dframe = data_frame[data_frame['Drive-wheels'].str.len() > 5]
        return right_dframe, left_dframe

    def check_dtype(self, data_frame):
        list_check = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
        for i in range(0, len(list_check)):
            if data_frame[list_check[i]].dtypes != np.int64:
                data_frame.drop(list_check[i], axis = 1, inplace = True)
        return data_frame

    def check_duplicate(self, data_frame):
        pass