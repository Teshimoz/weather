#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Original from http://www.avislab.com/blog/raspberry-pi-meteo_ru/
# Edited by Teshimoz - 2018, 2022

import sqlite3

print("Database creating...")

con = sqlite3.connect('weather.db')
cur = con.cursor()
cur.execute('CREATE TABLE weather (id REAL PRIMARY KEY, temperature REAL, pressure REAL, Humidity REAL, temperature_indoor REAL, pressure_indoor REAL, Humidity_indoor REAL, temperature_delta REAL, rainstate REAL, co2 INTEGER)')
con.commit()
con.close()

print("done!")
