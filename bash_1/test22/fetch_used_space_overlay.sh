#!/bin/bash
df -h | grep overlay | awk '{print $3}'
df -m | grep overlay | awk '{print $3}'
df | grep overlay | awk '{print $3}'
