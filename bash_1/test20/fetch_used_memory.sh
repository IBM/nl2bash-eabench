#!/bin/bash
free -h | grep Mem: | awk '{print $3}'
free -m | grep Mem: | awk '{print $3}'
free | grep Mem: | awk '{print $3}'