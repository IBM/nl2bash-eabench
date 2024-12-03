#!/bin/bash
df -h | grep overlay | awk '{print $3}'
