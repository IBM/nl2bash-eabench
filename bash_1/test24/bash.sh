#!/bin/bash
df -ih | grep overlay | awk '{print $3}'
