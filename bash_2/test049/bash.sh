#!/bin/bash
echo $(( ( $(date -d "Jan 20, 2024" +"%s") - $(date -d "Jan 12, 2023" +"%s") ) / (24*60*60) ))
