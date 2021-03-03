from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from config import config as cf
from service.model import ConnPostgre
from service.validation import Validation
import pandas as pd
import json
from flask import request

app = Flask(__name__)
app.debug = True

from controller import view

@app.route('/validate', methods=['POST'])
def validate():
    try:
        if request.files['file']:
            file = request.files.get('file')
            native_table, bad_table = validateData(file)

            bad_table.to_csv('D:/migration-data/src/data/badrecord_export_data.csv', index=False)
            native_table.to_csv('D:/migration-data/src/data/native_export_data.csv', index=False)
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
            bad_table.to_csv('D:/migration-data/src/data/badrecord_export_data.csv', index=False)

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

    native_table = val_data.anonimize(dataFrame)

    native_table, bad_table_v1 = val_data.check_nan(native_table)
    native_table, bad_table_v2 = val_data.check_length(native_table)
    native_table, bad_table_v3 = val_data.check_duplicate(native_table)

    native_table = val_data.check_dtype(native_table)
    native_table = val_data.rename(native_table)

    return native_table, pd.concat([bad_table_v1, bad_table_v2, bad_table_v3])