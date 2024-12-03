#!/bin/bash

awk '{print NR" "$0}' file.txt > temp_file && mv temp_file file.txt
