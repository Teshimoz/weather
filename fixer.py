#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sqlite3
import time
import datetime
# import re
# import os
from datetime import datetime


# Set database path
home_dir = "/home/pi/weather/"
database_name = 'weather.db'
database_name_simple = database_name.split('.')[0]

# header of db, to filter fields for different fixes
header = ['id', 'temperature', 'pressure', 'humidity', 'temperature_indoor', 'pressure_indoor', 'humidity_indoor', 'temperature_delta', 'rainstate', 'co2']

co2_alarm_level = 800  # this value I set to write by sensor if there is no data
temp_alarm_level = 20.99  # this value I get when sensor glitching
hum_alarm_level = 81.89  # to find problem rows by another field, humidity
# Set sql connection
con = sqlite3.connect(home_dir + database_name)


# Function for sql query
def get_from_sql(connection, sql):
    cursor=connection.cursor()
    cursor.execute(sql)
    return cursor.fetchall()


# Get problem ids
def get_problem_ids(field):
    if field == 'co2':
        alarm_level = co2_alarm_level
    elif field == 'temperature_indoor':
        alarm_level = temp_alarm_level
    elif field == 'humidity':
        alarm_level = hum_alarm_level
    query_id = "SELECT id FROM {} WHERE {} = {} ORDER BY id DESC".format(database_name_simple, field, alarm_level)
    problem_id_raw = get_from_sql(con, query_id)
    id_list = [x[0] for x in problem_id_raw]
    return id_list


# function to get previous row
def get_previuos(id):
    query_previous = "SELECT * FROM {} WHERE id < {} ORDER BY id DESC LIMIT 1".format(database_name_simple, id)
    previous_row = list(get_from_sql(con, query_previous)[0])
    return previous_row


# function to get the row
def get_current_row(id):
    query_current_row = "SELECT * FROM {} WHERE id = {}".format(database_name_simple, id)
    current_row = list(get_from_sql(con, query_current_row)[0])
    return current_row


# function to get next row
def get_next_row(id):
    query_next = "SELECT * FROM {} WHERE id > {} ORDER BY id LIMIT 1".format(database_name_simple, id)
    next_row = list(get_from_sql(con, query_next)[0])
    return next_row

# Fix value in current row by average # it could be a problem if first or last value is broken
def fix_problem_row(previous_row, current_row, next_row, field):
    # convert to dictionary
    previous_row_dict = dict(zip(header, previous_row))
    current_row_dict = dict(zip(header, current_row))
    next_row_dict = dict(zip(header, next_row))
    if field == 'co2':
        current_row_dict['co2'] = int((previous_row_dict['co2'] + next_row_dict['co2']) / 2)
    elif field == 'temperature_indoor' or 'humidity':
        flds_list = ['temperature', 'pressure', 'humidity', 'temperature_indoor', 'pressure_indoor', 'humidity_indoor', 'temperature_delta']
        for fld in flds_list:
            current_row_dict[fld] = (previous_row_dict[fld] + next_row_dict[fld]) / 2
    return current_row_dict


def update_table(upd_row):
    query_replace = "REPLACE INTO {0} VALUES({1}, '{2}', {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10})".format(database_name_simple,
                                                               upd_row['id'],
                                                               upd_row['temperature'],
                                                               upd_row['pressure'],
                                                               upd_row['humidity'],
                                                               upd_row['temperature_indoor'],
                                                               upd_row['pressure_indoor'],
                                                               upd_row['humidity_indoor'],
                                                               upd_row['temperature_delta'],
                                                               upd_row['rainstate'],
                                                               upd_row['co2'])
    cur = con.cursor()
    cur.execute(query_replace)
    con.commit()


# fix this field (meta function)
def fix_this_field(field):
    # get ids of rows to fix
    id_list = get_problem_ids(field)
    if len(id_list) > 1:
        print(f'There are {len(id_list)} problem rows for {field}:')
        print(id_list)
    elif len(id_list) == 1:
        print(f'There is one problem row for {field}:')
        print(id_list)
    else:
        print(f'There is nothing to fix for {field}')
        print()
        return

    for id in id_list:
        previous_row = get_previuos(id)
        current_row = get_current_row(id)
        next_row = get_next_row(id)
        print('Fixing...')
        upd_row = fix_problem_row(previous_row, current_row, next_row, field)
        update_table(upd_row)

    # check if there are any problem ids after fixing:
    id_list = get_problem_ids(field)
    if len(id_list) > 1:
        print(f'There are {len(id_list)} problem rows after fixing {field}:')
        print(id_list)
    elif len(id_list) == 1:
        print(f'There is one problem row after fixing {field}:')
        print(id_list)
    else:
        print(f'There are no problem rows after fixing {field}')
    print()

# Intro
print(f'Will check and fix rows at {database_name}\n')

### main part
fix_this_field('co2')
fix_this_field('temperature_indoor') # including other fields from those sensors glitching simultaneously
# fix_this_field('humidity') # including other fields from those sensors glitching simultaneously

con.close()

