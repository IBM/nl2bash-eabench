#!/bin/bash
df -h | grep overlay | awk '{print $4}'
df -m | grep overlay | awk '{print $4}'
df | grep overlay | awk '{print $4}'
