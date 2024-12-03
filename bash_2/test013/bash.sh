#!/bin/bash
find ~ -type f -printf "%s %f\\n" | sort -n | tail -1
