#!/bin/bash
df -ih | grep overlay | awk '{print $3}'
df -im | grep overlay | awk '{print $3}'
df -i| grep overlay | awk '{print $3}'
