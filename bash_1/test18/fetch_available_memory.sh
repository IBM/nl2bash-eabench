#!/bin/bash
free -h | grep Mem: | awk '{print $7}'
free -m | grep Mem: | awk '{print $7}'
free | grep Mem: | awk '{print $7}'