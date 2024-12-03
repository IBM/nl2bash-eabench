#!/bin/bash

ps -eo pid,%cpu --sort=-%cpu | awk 'NR>1{print $1}' | head -5
