#!/bin/bash
df -ih | grep overlay | awk '{print $4}'
df -im | grep overlay | awk '{print $4}'
df | grep overlay | awk '{print $4}'
