#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Original from http://www.avislab.com/blog/raspberry-pi-meteo_ru/
# Edited by Teshimoz - 2018, 2019, 2022

import sqlite3
import urllib2
import time
import datetime
import re
import os
import openwin, closewin
from BME280 import *
from BME281 import *

# for raincheck
import RPi.GPIO as GPIO
# for co2 input
import subprocess

#========================================
# Settings
#========================================
home_dir = "/home/pi/weather/"
www_dir = "/var/www/html/weather/"
delete_data_older_than_days = 365
temperature_unit = 'C' # 'C' | 'F'
pressure_unit = 'mm Hg' # 'Pa' | 'mm Hg'
humidity_unit = '%'
temperature_unit_indoor = 'C' # 'C' | 'F'
temperature_unit_delta = 'C' # 'C' | 'F'
rainstate_unit = 'C'
pressure_unit_indoor = 'mm Hg' # 'Pa' | 'mm Hg'
humidity_unit_indoor = '%'
co2_unit = 'ppm'
#========================================
database_name = 'weather.db'
temperature_field = 'temperature'
temperature_field_indoor = 'temperature_indoor'
temperature_field_delta = 'temperature_delta'
rainstate_field = 'rainstate'
pressure_field = 'pressure'
humidity_field = 'humidity'
humidity_field_indoor = 'humidity_indoor'
co2_field = 'co2'

units = {temperature_field: temperature_unit, temperature_field_indoor: temperature_unit_indoor, pressure_field: pressure_unit, humidity_field: humidity_unit, humidity_field_indoor: humidity_unit_indoor, temperature_field_delta: temperature_unit_delta, rainstate_field: rainstate_unit, co2_field: co2_unit}

def convert(value, unit):
      	if unit == 'F':
		# Convert from Celsius to Fahrenheit
		return round(1.8 * value + 32.0, 2)
	if unit == 'mm Hg':
		 #Convert from Pa to mm Hg
		return round(value * 0.00750061683, 2)
	return value

def get_chart_data(field, days):
	global units
	result = ""
	start_time =  time.time() - 86400*days
	SQL = "SELECT id, {0} FROM weather WHERE (id > {1}) ORDER BY id DESC".format(field, start_time)
	cur.execute(SQL)
	for row in cur:
		value = convert(row[1], units[field])
		result += "[new Date({0}), {1}], ".format(int(row[0]*1000), value)
	result = re.sub(r', $', '', result)
	return result

def get_chart_data_combo(field1, field2, days):
	global units
	result = ""
	start_time = time.time() - 86400 * days
	SQL = "SELECT id, {0}, {1} FROM weather WHERE (id > {2}) ORDER BY id DESC".format(field1, field2, start_time)
	cur.execute(SQL)
	for row in cur:
		value1 = convert(row[1], units[field1])
		value2 = convert(row[2], units[field2])
		result += "[new Date({0}), {1}, {2}], ".format(int(row[0]*1000), value1, value2)
	result = re.sub(r', $', '', result)
	return result

def get_mean_data(field, days):
	global units
	result = list()
	start_time = time.time() - 86400 * days
	SQL = "SELECT {0} FROM weather WHERE (id > {1}) ORDER BY id DESC".format(field, start_time)
	cur.execute(SQL)
	for row in cur:
		value = convert(row[0], units[field])
		result.append(value)
	if len(result) > 0:
		result_mean = sum(result)/len(result)
	else:
		result_mean = 0
	if round(result_mean, 2) == result_mean:
		return str(result_mean)
	else:
		return(str(round(result_mean, 2)))


# text update function
def update_txt(txt, general_fields_list, days, function):
	counter = 1
	suffix = ''
	if function != 'get_data':
		suffix = '_' + function
	days_map = {1: '24h', 7: '7d', 30: '30d'}
	suffix += days_map[days]
	for field in general_fields_list:
		if function == 'combo' and counter < len(general_fields_list):
			field2 = general_fields_list[counter]
		counter += 1
		htm_name = '{' + field + suffix + '}'
		field1 = field
		if function == 'mean':
			txt = re.sub(htm_name, get_mean_data(field1, days), txt)
		elif function == 'combo':
			txt = re.sub(htm_name, get_chart_data_combo(field1, field2, days), txt)
		elif function == 'get_data':
			txt = re.sub(htm_name, get_chart_data(field1, days), txt)
	return txt

# general fields list definition
general_fields_list = [temperature_field,
            temperature_field_indoor,
			temperature_field_delta,
			co2_field,
			humidity_field,
			humidity_field_indoor,
			pressure_field,
			rainstate_field]

# Read data from Sensors
print(datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
ps = BME280()
ps_data = ps.get_data()
t_out = convert(ps_data['t'], units[temperature_field])
print "Temperature outdoor:", t_out, "°"+units[temperature_field], "Pressure:", convert(ps_data['p'], units[pressure_field]), units[pressure_field], "Humidity:", ps_data['h'], units[humidity_field]

ps_indoor = BME281()
ps_indoor_data = ps_indoor.get_data()
t_in = convert(ps_indoor_data['t1'], units[temperature_field_indoor])
print "Temperature indoor: ", t_in, "°"+units[temperature_field_indoor], "Pressure:", convert(ps_indoor_data['p1'], units[pressure_field]), units[pressure_field], "Humidity:", ps_indoor_data['h1'], units[humidity_field_indoor]

# calculation of temperature difference between inside and outside
delta = t_in - t_out
print "Delta temperature:   ",delta, "°"+units[temperature_field_delta], "(= indoor - outdoor)"
# actions by temperature delta
if delta > .5:
    print "Delta > 0.5 °"+units[temperature_field_delta],", keep your windows open"
else:
    if delta < -.5:
        print "Delta < -0.5 °"+units[temperature_field_delta],", close window, keep your coolness"
    else:
        print "-0.5 < Delta < 0.5 °"+units[temperature_field_delta],", same same"

# rainckeck
GPIO.setmode(GPIO.BOARD)
GPIO.setup(7, GPIO.IN)
rainstate = GPIO.input(7)
rainstate = (rainstate - 1) ** 2

# CO2 data input
cmd = [ 'sudo', 'python2' ,'-m', 'mh_z19' ]
try:
	co2 = int(subprocess.Popen(cmd, stdout=subprocess.PIPE).communicate()[0].split(' ')[1].replace("}", ""))
except:
	co2 = 0
print 'CO2 level:',co2, 'ppm'

# Connect to database
con = sqlite3.connect(home_dir + database_name)
cur = con.cursor()

# Insert new record
# Check order of dates (Power outage leads to wrong record of data)
time_now = time.time()

SQL = "SELECT id FROM weather ORDER BY id DESC LIMIT 1".format()
cur.execute(SQL)
last_id = cur.fetchone()[-1]
if time_now > last_id:
    #write a data
	SQL = "INSERT INTO weather VALUES({0}, '{1}', {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9})".format(time_now,
																								  ps_data['t'],
																								  ps_data['p'],
																								  ps_data['h'],
																								  ps_indoor_data['t1'],
																								  ps_indoor_data['p1'],
																								  ps_indoor_data['h1'],
																								  delta, rainstate, co2)
	cur.execute(SQL)
	con.commit()
else:
    pass 

# Delete data older than X days
start_time =  time.time() - 86400 * delete_data_older_than_days
SQL = "DELETE FROM weather WHERE (id < {0})".format(start_time)
cur.execute(SQL)
con.commit()

# Read template & make index.htm
f = open(home_dir+'templates/index.tpl', 'r')
txt = f.read()
f.close()

# Prepare html
date_time = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M')

# Units - only
txt = re.sub('{temperature_unit}', units[temperature_field], txt)
txt = re.sub('{pressure_unit}', units[pressure_field], txt)
txt = re.sub('{humidity_unit}', units[humidity_field], txt)

txt = re.sub('{temperature_unit_indoor}', units[temperature_field_indoor], txt)
txt = re.sub('{humidity_unit_indoor}', units[humidity_field_indoor], txt)

txt = re.sub('{temperature_unit_delta}', units[temperature_field_delta], txt)
txt = re.sub('{rainstate_unit}', units[rainstate_field], txt)
txt = re.sub('{co2_unit}', units[co2_field], txt)

# Current data - misc
txt = re.sub('{time}', date_time, txt)
txt = re.sub('{temperature}', str(convert(ps_data['t'], units[temperature_field])), txt)
txt = re.sub('{pressure}', str(convert(ps_data['p'], units[pressure_field])), txt)
txt = re.sub('{humidity}', str(ps_data['h']), txt)

txt = re.sub('{temperature_indoor}', str(convert(ps_indoor_data['t1'], units[temperature_field_indoor])), txt)
txt = re.sub('{pressure}', str(convert(ps_indoor_data['p1'], units[pressure_field])), txt)
txt = re.sub('{humidity_indoor}', str(ps_indoor_data['h1']), txt)

txt = re.sub('{temperature_delta}', str(convert(delta, units[temperature_field_delta])), txt)
txt = re.sub('{rainstate}', str(convert(rainstate, units[rainstate_field])), txt)
txt = re.sub('{co2}', str(convert(co2, units[co2_field])), txt)


# update charts data by function
days_list = [1, 7, 30]
for days in days_list:
	# update chart data combined ('combo')
	txt = update_txt(txt, general_fields_list, days, function='combo')
	# update chart data, one graph ('get_data')
	txt = update_txt(txt, general_fields_list, days, function='get_data')
	# update means ('mean')
	txt = update_txt(txt, general_fields_list, days, function='mean')


# flat format, not "dry", but more efficient
# Day ago - 1

# get_chart_data_combo
# txt = re.sub('{temperature_combo24h}', get_chart_data_combo(temperature_field, temperature_field_indoor, 1), txt)
# txt = re.sub('{humidity_combo24h}', get_chart_data_combo(humidity_field, humidity_field_indoor, 1), txt)

# get_chart_data (could be a function with input as: list of names and fields, number of days)
# txt = re.sub('{temperature24h}', get_chart_data(temperature_field, 1), txt)
# txt = re.sub('{pressure24h}', get_chart_data(pressure_field, 1), txt)
# txt = re.sub('{humidity24h}', get_chart_data(humidity_field, 1), txt)
#
# txt = re.sub('{temperature_indoor24h}', get_chart_data(temperature_field_indoor, 1), txt)
# txt = re.sub('{pressure24h}', get_chart_data(pressure_field, 1), txt)
# txt = re.sub('{humidity_indoor24h}', get_chart_data(humidity_field_indoor, 1), txt)
#
# txt = re.sub('{temperature_delta24h}', get_chart_data(temperature_field_delta, 1), txt)
# txt = re.sub('{rainstate24h}', get_chart_data(rainstate_field, 1), txt)
# txt = re.sub('{co224h}', get_chart_data(co2_field, 1), txt)

# get_mean_data
# txt = re.sub('{temperature_mean24h}', get_mean_data(temperature_field, 1), txt)
# txt = re.sub('{temperature_indoor_mean24h}', get_mean_data(temperature_field_indoor, 1), txt)
# txt = re.sub('{delta_mean24h}', get_mean_data(temperature_field_delta, 1), txt)
# txt = re.sub('{co2_mean24h}', get_mean_data(co2_field, 1), txt)
# txt = re.sub('{humidity_mean24h}', get_mean_data(humidity_field, 1), txt)
# txt = re.sub('{humidity_indoor_mean24h}', get_mean_data(humidity_field_indoor, 1), txt)
# txt = re.sub('{pressure_mean24h}', get_mean_data(pressure_field, 1), txt)


# Last week - 7

# get_chart_data_combo
# txt = re.sub('{temperature_combo7d}', get_chart_data_combo(temperature_field, temperature_field_indoor, 7), txt)
# txt = re.sub('{humidity_combo7d}', get_chart_data_combo(humidity_field, humidity_field_indoor, 7), txt)

# get_chart_data
# txt = re.sub('{temperature7d}', get_chart_data(temperature_field, 7), txt)
# txt = re.sub('{pressure7d}', get_chart_data(pressure_field, 7), txt)
# txt = re.sub('{humidity7d}', get_chart_data(humidity_field, 7), txt)
#
# txt = re.sub('{temperature_indoor7d}', get_chart_data(temperature_field_indoor, 7), txt)
# txt = re.sub('{pressure7d}', get_chart_data(pressure_field, 7), txt)
# txt = re.sub('{humidity_indoor7d}', get_chart_data(humidity_field_indoor, 7), txt)
#
# txt = re.sub('{delta7d}', get_chart_data(temperature_field_delta, 7), txt)
# txt = re.sub('{rainstate7d}', get_chart_data(rainstate_field, 7), txt)
# txt = re.sub('{co27d}', get_chart_data(co2_field, 7), txt)

# get_mean_data
# txt = re.sub('{temperature_mean7d}', get_mean_data(temperature_field, 7), txt)
# txt = re.sub('{temperature_indoor_mean7d}', get_mean_data(temperature_field_indoor, 7), txt)
# txt = re.sub('{delta_mean7d}', get_mean_data(temperature_field_delta, 7), txt)
# txt = re.sub('{co2_mean7d}', get_mean_data(co2_field, 7), txt)
# txt = re.sub('{humidity_mean7d}', get_mean_data(humidity_field, 7), txt)
# txt = re.sub('{humidity_indoor_mean7d}', get_mean_data(humidity_field_indoor, 7), txt)
# txt = re.sub('{pressure_mean7d}', get_mean_data(pressure_field, 7), txt)


# Last month - 30

# get_chart_data_combo
# txt = re.sub('{temperature_combo30d}', get_chart_data_combo(temperature_field, temperature_field_indoor, 30), txt)
# txt = re.sub('{humidity_combo30d}', get_chart_data_combo(humidity_field, humidity_field_indoor, 30), txt)

# get_chart_data
# txt = re.sub('{temperature30d}', get_chart_data(temperature_field, 30), txt)
# txt = re.sub('{pressure30d}', get_chart_data(pressure_field, 30), txt)
# txt = re.sub('{humidity30d}', get_chart_data(humidity_field, 30), txt)
#
# txt = re.sub('{temperature_indoor30d}', get_chart_data(temperature_field_indoor, 30), txt)
# txt = re.sub('{pressure30d}', get_chart_data(pressure_field, 30), txt)
# txt = re.sub('{humidity_indoor30d}', get_chart_data(humidity_field_indoor, 30), txt)
#
# txt = re.sub('{delta30d}', get_chart_data(temperature_field_delta, 30), txt)
# txt = re.sub('{rainstate30d}', get_chart_data(rainstate_field, 30), txt)
# txt = re.sub('{co230d}', get_chart_data(co2_field, 30), txt)

# get_mean_data
# txt = re.sub('{temperature_mean30d}', get_mean_data(temperature_field, 30), txt)
# txt = re.sub('{temperature_indoor_mean30d}', get_mean_data(temperature_field_indoor, 30), txt)
# txt = re.sub('{delta_mean30d}', get_mean_data(temperature_field_delta, 30), txt)
# txt = re.sub('{co2_mean30d}', get_mean_data(co2_field, 30), txt)
# txt = re.sub('{humidity_mean30d}', get_mean_data(humidity_field, 30), txt)
# txt = re.sub('{humidity_indoor_mean30d}', get_mean_data(humidity_field_indoor, 30), txt)
# txt = re.sub('{pressure_mean30d}', get_mean_data(pressure_field, 30), txt)


# Writing file index.htm
f = open(www_dir+'index.htm','w')
f.write(txt)
f.close()

# Database connection close
con.close()
