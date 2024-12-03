#!/bin/bash

awk 'BEGIN{counter=101} !/^\s*$/{print counter" "$0; counter++} /^\s*$/{print}' file.txt > temp_file && mv temp_file file.txt