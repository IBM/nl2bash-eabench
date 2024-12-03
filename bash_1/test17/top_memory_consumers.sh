#!/bin/bash
ps -eo pid,%mem --sort=-%mem | awk 'NR>1{print $1}' | head -5
