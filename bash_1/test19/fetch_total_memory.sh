#!/bin/bash
free -h | grep Mem: | awk '{print $2}'
free -m | grep Mem: | awk '{print $2}'
free | grep Mem: | awk '{print $2}'