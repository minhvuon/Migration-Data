from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from config import config as cf
from service.model import ConnPostgre
from service.validation import Validation
import pandas as pd
import numpy as np
import json
from flask import request
from datetime import date, datetime
import os

app = Flask(__name__)
app.debug = True

from controller import view

@app.route('/validate', methods=['POST'])
def validate():
    try:
        if request.files['file']:
            file = request.files.get('file')
            native_table, bad_table = validateData(file)
            
            name_file = get_time()
            name_folder = get_date()

            os.chdir(cf.PATH_DATA)
            if check_folder(name_folder) == False:
                create_folder(name_folder)

            bad_table.to_csv(cf.PATH_DATA + name_folder + '/badrecord_export_data [' + name_file + '].csv', index=False)
            native_table.to_csv(cf.PATH_DATA + name_folder + '/native_export_data [' + name_file + '].csv', index=False)
        else:
            return {
                'status': 'VALIDATION_FAILED',
                'message': "Missing data csv"}, 500
    except Exception as ex:
         return {
            'status': 'VALIDATION_FAILED',
            'message': str(ex)}, 500
    return {
        "msg": "VALIDATION_SUCCESS"
        }, 200

@app.route('/insert', methods=['POST'])
def insert():
    msg = ""
    table_name = 'car'
    try:
        if request.files['file']:
            file = request.files.get('file')
            native_table, bad_table = validateData(file)

            change_dtype(native_table, 'symboling', int)
            change_dtype(native_table, 'normalized_losses', int)
            change_dtype(native_table, 'wheel_base', float)
            change_dtype(native_table, 'length', float)
            change_dtype(native_table, 'width', float)
            change_dtype(native_table, 'height', float)
            change_dtype(native_table, 'curb_weight', int)
            change_dtype(native_table, 'engine_size', int)
            change_dtype(native_table, 'bore', float)
            change_dtype(native_table, 'stroke', float)
            change_dtype(native_table, 'horsepower', int)
            change_dtype(native_table, 'peak_rpm', int)
            change_dtype(native_table, 'city_mpg', int)
            change_dtype(native_table, 'highway_mpg', int)
            change_dtype(native_table, 'price', int)

            name_file = get_time()
            name_folder = get_date()

            os.chdir(cf.PATH_DATA)
            if check_folder(name_folder) == False:
                create_folder(name_folder)

            bad_table.to_csv(cf.PATH_DATA + name_folder + '/badrecord_export_data [' + name_file + '].csv', index=False)

            conn = ConnPostgre(cf.HOST, cf.USER, cf.PASSWORD, cf.DATABASE)
            conn.sql_insert(table_name, native_table)
            msg = ("Table %s created successfully." %table_name)
        else:
            return {
                'status': 'INSERT_FAILED',
                'message': "Missing data csv"}, 500
    except Exception as ex:
        return {
            'status': 'INSERT_FAILED',
            'message': str(ex)}, 500
    return {
        'status': 'INSERT_SUCCESS',
        "msg" : msg}, 200

def validateData(file_csv):
    data = pd.read_csv(file_csv, sep=',')
    dataFrame = pd.DataFrame(data)

    val_data = Validation()

    pattern = "/\d+/"
    replace = '/01/'
    col_name_ano = 'Load-date'
    native_table = val_data.anonimize(dataFrame, col_name_ano, pattern, replace)

    list_check = ['Width', 'Bore', 'Height', 'Normalized-losses', 'Stroke', 'Length', 'Horsepower', 'peak-rpm', 'Engine-size']
    dframe = val_data.validate_all(native_table, list_check)
    native_table = dframe[dframe['check']==1]
    bad_table_v0 = dframe[dframe['check']==0]
    native_table.pop("check")
    bad_table_v0.pop("check")

    col_name_cn = 'Price'
    native_table, bad_table_v1 = val_data.check_nan(native_table, col_name_cn)

    col_name_cl = 'Drive-wheels'
    length = 5
    native_table, bad_table_v2 = val_data.check_length(native_table, col_name_cl, length)
    
    native_table, bad_table_v3 = val_data.check_duplicate(native_table)

    # list_check = ['Height', 'Width', 'Length', 'Engine-size', 'Bore', 'Stroke', 'Price']
    # native_table = val_data.check_dtype(native_table, list_check)

    dict_name = {"No": "no",
    "Symboling": "symboling",
    "Normalized-losses": "normalized_losses",
    "Make": "make",
    "Fuel-type": "fuel_type",
    "Aspiration": "aspiration",
    "Num-of-doors": "num_of_doors",
    "Body-style": "body_style",
    "Drive-wheels": "drive_wheel",
    "Engine-location": "engine_location",
    "Wheel-base": "wheel_base",
    "Length": "length",
    "Width": "width",
    "Height": "height",
    "Curb-weight": "curb_weight",
    "Engine-type": "engine_type",
    "Num-of-cylinders": "num_of_cylinders",
    "Engine-size": "engine_size",
    "Fuel-system": "fuel_system",
    "Bore": "bore",
    "Stroke": "stroke",
    "Compression-ratio": "compression_ratio",
    "Horsepower": "horsepower",
    "peak-rpm": "peak_rpm",
    "city-mpg": "city_mpg",
    "highway-mpg": "highway_mpg",
    "Price": "price",
    "Load-date": "load_date"}
    native_table = val_data.rename(native_table, dict_name)
    
    return native_table, pd.concat([bad_table_v0, bad_table_v1, bad_table_v2, bad_table_v3])

def get_date():
    today = date.today()
    current_day = today.strftime("%B %d, %Y")
    return current_day

def get_time():
    now = datetime.now()
    current_time = now.strftime("%H")
    # current_time = now.strftime("%H:%M:%S")
    return current_time

def check_folder(name_folder):
    list_folder = os.listdir()
    return name_folder in list_folder

def create_folder(name_folder):
    os.mkdir(name_folder)

def change_dtype(data_frame, col_name, dtype):
    data_frame[col_name] = data_frame.loc[:,col_name].astype(dtype)
    return data_frame
