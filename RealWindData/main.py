# Pydap needs to be installed
# Documentation for pydap:  https://pydap.readthedocs.io/en/latest/index.html

import csv
import os
import datetime
import math
import pandas as pd
import numpy as np

from pydap.client import open_url
from pathlib import Path

#---------------------------------------------#
#                   CHANGE                    #
#---------------------------------------------#

# DEFINE RANGES

# Latitude value range:                 -78.375, 78.375
# Latitude distance between values:     0.25
# Latitude range of values:             0..627

# Longitude value range:                0.125, 359.875
# Longitude distance between values:    0.25
# Longitude range of values:            0..1439

# time start_date:                      1987-07-02 UTC
# time stop_date:                       2011-12-31 UTC
# time unit:                            hours since start date
# time range of values:                 0..35795

# Real world latitude and longitude values

#latRealMin = -50
#latRealMax = -30
#lonRealMin = 90
#lonRealMax = 140
#timeReal = datetime.datetime(2010,1,1,12)

#1=high precision (use each lon and lat value), 10=low precision (use every 10th value)
#precisionLat = 3
#precisionLon = 10

latRealMin = -50
latRealMax = -30
lonRealMin = 70
lonRealMax = 90
timeReal = datetime.datetime(2010,1,1,12)
precisionLat = 4
precisionLon = 4

#---------------------------------------------#
#                DO NOT CHANGE                #
#---------------------------------------------#

# Ranges for complete array

latRangeMin = 0
latRangeMax = 627
lonRangeMin = 0
lonRangeMax = 1439
timeRangeMin = 0
timeRangeMax = 35795

# TRANSFER LATITUDE, LONGITUDE AND TIME TO INTEGER VALUES

latArrayMin = math.floor( (latRealMin + 78.375) / 0.25 )
latArrayMax = math.ceil( (latRealMax + 78.375 ) / 0.25 )
lonArrayMin = math.floor( ( lonRealMin - 0.125 ) / 0.25 )
lonArrayMax = math.ceil( ( lonRealMax - 0.125 ) / 0.25 )

if lonArrayMax > lonRangeMax:
    lonArrayMax = lonRangeMax
if lonArrayMax < lonRangeMin:
    lonArrayMax = lonRangeMin
if lonArrayMin < lonRangeMin:
    lonArrayMin = lonRangeMin
if lonArrayMin > lonRangeMax:
    lonArrayMin = lonRangeMax - 1

if latArrayMax > latRangeMax:
    latArrayMax = latRangeMax
if latArrayMax < latRangeMin:
    latArrayMax = latRangeMin
if latArrayMin < latRangeMin:
    latArrayMin = latRangeMin
if latArrayMin > latRangeMax:
    latArrayMin = latRangeMax - 1


startDate = datetime.datetime(1987,7,2,0,0,0)
endDate = datetime.datetime(2011,12,31,23,59,59)
duration = endDate - startDate
duration_in_days = duration.days
duration_in_seconds = duration.seconds
total_duration_in_seconds = duration_in_days * 86400 + duration_in_seconds
total_duration_in_hours = divmod(total_duration_in_seconds,3600)[0]


# Steps are always made in 6 hours
dur = timeReal - startDate
dur_in_days = dur.days
dur_in_seconds = dur.seconds
total_dur_in_seconds = dur_in_days * 86400 + dur_in_seconds
total_dur_in_hours = divmod( total_dur_in_seconds, 3600)[0]
timeArray = math.floor( total_dur_in_hours / 6 )

if timeArray < timeRangeMin:
    timeArray = timeRangeMin
if timeArray > timeRangeMax:
    timeArray = timeRangeMax

# Set correct ranges for precision


print('')
print('INPUT LON =[',lonRealMin,':',lonRealMax,']')
print('INPUT LAT =[',latRealMin,':',latRealMax,']')
print('INPUT DATE =',str(timeReal))
print('PRECISION LAT =' ,str(precisionLat))
print('PRECISION LON =' ,str(precisionLon))

# CREATE URL

lonRange = '[' + str( lonRangeMin ) + ':1:' + str( lonRangeMax ) + ']'
latRange = '[' + str( latRangeMin ) + ':1:' + str( latRangeMax )+ ']'
timeRange = '[' + str( timeRangeMin ) + ':1:' + str( ( timeRangeMax ) ) + ']' #+3
uwndRange = timeRange + latRange + lonRange
vwndRange = timeRange + latRange + lonRange

generalUrl = 'https://thredds.jpl.nasa.gov/thredds/dodsC/ncml_aggregation/OceanWinds/ccmp/aggregate__CCMP_MEASURES_ATLAS_L4_OW_L3_0_WIND_VECTORS_FLK.ncml'

resultUrl = generalUrl + '?' + 'lon' + lonRange + ',' + 'lat' + latRange + ',' + 'time' + timeRange + ',' + 'uwnd' + uwndRange + ',' + 'vwnd' + vwndRange

print('')
print('URL:', resultUrl)

# OPEN URL

dataset = open_url( resultUrl )

# DOWNLOAD DATA BASE TYPE

lonData = dataset.lon.data[ lonArrayMin : lonArrayMax : precisionLon ]
latData = dataset.lat.data[ latArrayMin : latArrayMax : precisionLat ]

print('USED VALUES LON: ', lonData )
print('USED VALUES LAT: ', latData )

timeData = dataset.time.data[ timeArray ]
passedHours = timeData[0]
usedDate = startDate + datetime.timedelta( hours = passedHours )

print('USED DATE: ', usedDate )

# DOWNDLOAD DATA GRID TYPE

uwndData = dataset.uwnd.uwnd.data
vwndData = dataset.vwnd.vwnd.data

# WRITE DATA TO ARRAYS

#uwndData = uwndData[ timeArray, latArrayMin : latArrayMax, lonArrayMin : lonArrayMax ][0]
uwndData = uwndData[ timeArray, latArrayMin : latArrayMax : precisionLat, lonArrayMin : lonArrayMax : precisionLon ][0]
uwndArray = []

for row in uwndData:

    singleArray = []

    for data in row:

        singleArray.append( int(data) )

    uwndArray.append(singleArray)


#vwndData = vwndData[ timeArray, latArrayMin : latArrayMax, lonArrayMin : lonArrayMax ][0]
vwndData = vwndData[ timeArray, latArrayMin : latArrayMax : precisionLat, lonArrayMin : lonArrayMax : precisionLon ][0]
vwndArray = []

for row in vwndData:

    singleArray = []

    for data in row:

        singleArray.append( int(data) )

    vwndArray.append(singleArray)

# CREATE STORAGE PATH

root_path = str( Path.home() ) + "\\Desktop\\WindData"

if not os.path.exists(root_path):
    os.makedirs(root_path)

now = datetime.datetime.now()
file_path = root_path + "\\" + now.strftime('%y-%m-%d---%H-%M-%S') + '.csv'

# WRITE DATA TO CSV FILE

with open( file_path, 'w', newline='' ) as file:
    writer = csv.writer(file)
    writer.writerow(('U'))
    writer.writerows(uwndArray)
    writer.writerow( ('V') )
    writer.writerows(vwndArray)
    file.close()

print('')
print('FINISHED: Data has been stored to', file_path)



