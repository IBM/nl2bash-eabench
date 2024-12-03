#!/bin/bash
#
# Write a bash script to output the Julian Day Number of its argument which is in yyyy-mm-dd format.
#
# -4712 January 1
# 1582-oct-5 thru 1582-oct-14 are missing
#
# JDN = (1461 × (Y + 4800 + (M − 14)/12))/4 + (367 × (M − 2 − 12 × ((M − 14)/12)))/12 − (3 × ((Y + 4900 + (M - 14)/12)/100))/4 + D − 32075
#
# 153 comes from starting in March and lumping 5 months together: 31+30+31+30+31
# 1461 comes from four-year leap-cycle: 4*365+1
#
# JDN =
#   (1461 * (Y + 4800 + (M − 14)/12))/4 +
#   (367 * (M − 2 − 12 * ((M − 14)/12)))/12 −
#   (3 * ((Y + 4900 + (M - 14)/12)/100))/4 +
#   D − 32075
#
#   A = (M-14)/12  produces -1 for Jan and Feb; zero otherwise
#
#          A  M-2-12*A  367*B/12
#   Jan   -1    11        336 31
#   Feb   -1    12        367 31
#   Mar    0     1         30
#   Apr    0     2         61 31
#   May    0     3         91 30
#   Jun    0     4        122 31
#   Jul    0     5        152 30
#   Aug    0     6        183 31
#   Sep    0     7        214 31
#   Oct    0     8        244 30
#   Nov    0     9        275 31
#   Dec    0    10        305 30
#  
# JDN =
#   (1461 * (Y+A + 4800))/4 +      leap-year cycles times days in leap-year cycle
#   (367 * (M − 2 − 12*A))/12 −    days from 1-Mar to date
#   (3 * ((Y+A + 4900)/100))/4 +   Gregory's leap-century adjustment every 400 years?
#   D − 32075                      day of the month minus serious adjustment
#
#
# 2000-02-29 2451604 *
# 2016-02-29 2457448 * 
# 2024-06-14 2460476 *
# 1582-10-15 2299161 *
#

jdn() {
    local Y=$1
    local M=$2
    local D=$3
    echo $(( (1461 * (Y + 4800 + (M - 14)/12))/4 + (367 * (M - 2 - 12 * ((M - 14)/12)))/12 - (3 * ((Y + 4900 + (M - 14)/12)/100))/4 + D - 32075 ))
}

# This one is sometimes high by one day
kdn() {
    local Y=$1
    local M=$2
    local D=$3
    A=$(( Y / 100 ))
    B=$(( A / 4 ))
    C=$(( 2 - A + B ))
    E=$(( 365*(Y+4716) + (Y+4716)/4 ))       # 365.25 * (Y+4716)
    F=$(( 30*(M+1) + 6001*(M+1)/10000 ))     # 30.6001*(M+1)
    echo $(( C + D + E + F - 1524 -1 ))
}

ldn() {
    local Y=$1
    local M=$2
    local D=$3
    echo $(( D + (153*M+2)/5 +365*Y + Y/4 - Y/100 + Y/400 - 32045 ))
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 yyyy-mm-dd"
    exit 1
fi

if ! [[ $1 =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$ ]]; then
    echo "Invalid date format: $1"
    exit 1
fi

IFS='-' read -r y m d <<< "$1"
jdn $y $m $d

#kdn $(( y - 1 )) $(( m + 12 )) $d

