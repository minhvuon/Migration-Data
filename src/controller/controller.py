from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from config import config as cf
from service.model import ConnPostgre
import pandas as pd
import json

app = Flask(__name__)
app.debug = True

from controller import view

@app.route('/insert')
def insert():
    data = pd.read_csv('D:/migration-data/src/data/car_sample_data.csv', sep=';', index_col=0)
    dataFrame = pd.DataFrame(data)

    conn = ConnPostgre(cf.HOST, cf.USER, cf.PASSWORD, cf.DATABASE)
    conn.sql_insert('carv2', dataFrame)
    return 'Success'