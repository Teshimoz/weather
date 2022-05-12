# Weather
Simple Weather Station
Based on script from this article:
https://blog.avislab.com/raspberry-pi-meteo_ru/

Script for Raspberry Pi to log environment data and generate htm file with graphs of:
  temperature and humidity from two BME280 sensors, 
  pressure from one of them, 
  co2 level from MH-Z19 sensor
  
Graphs generated for day, week and month.
You can check out printscreen here in folder 'pictures'

In this fork added:
- adapted for python 3
- second BME280 sensor (indoor), the file BME280.py updated accordingly
- co2 sensor (have to install mh-z19: pip install mh-z19)
- graph of temperature difference
- visualization of indoor and outdoor data on same graph
- mean values for each period and type
- data fixer for power outage (test for now)
- option to update final htm file by compact function in script to get more flexibility 
- option to connect rain sensor and log it's status

Tested on Raspberry Pi Zero 1.3
