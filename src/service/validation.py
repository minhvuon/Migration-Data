import numpy as np
import pandas as pd
import re

class Validation:
    def __init__(self):
        pass

    def merge_and_duplicate(self, data_frame1, data_frame2):
        right_dframe = pd.concat([data_frame1, data_frame2])
        right_dframe = right_dframe.drop_duplicates(keep=False)
        return right_dframe

    def check_nan(self, data_frame):
        right_dframe = data_frame[(data_frame['Price'].str.isnumeric() == True)]
        left_dframe = self.merge_and_duplicate(data_frame, right_dframe)
        return right_dframe, left_dframe

    def check_length(self, data_frame, length):
        right_dframe = data_frame[data_frame['Drive-wheels'].str.len() <= length]
        left_dframe = data_frame[data_frame['Drive-wheels'].str.len() > length]
        return right_dframe, left_dframe

    def check_dtype(self, data_frame, list_check):
        for i in range(0, len(list_check)):
            if data_frame[list_check[i]].dtypes != np.int64:
                data_frame.drop(list_check[i], axis = 1, inplace = True)
        return data_frame

    def check_duplicate(self, data_frame):
        left_dframe = data_frame[data_frame.duplicated()]
        right_dframe = data_frame.drop_duplicates(keep=False)
        return right_dframe, left_dframe

    def rename(self, data_frame):
        return data_frame.rename(columns={"Fuel-type": "type", "Num-of-cylinders": "Num_cylinders"})

    def anonimize(self, data_frame):
        pattern = "/\d+/"
        replace = '/01/'
        temp_frame = []
        for string in data_frame['Load-date']:
            stringv1 = re.sub(pattern, replace, string, 1)
            temp_frame.append(stringv1)
        temp_frame = pd.DataFrame(temp_frame, columns=['Load-date'])
        data_frame['Load-date'] = temp_frame
        return data_frame