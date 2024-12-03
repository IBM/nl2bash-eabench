#!/bin/bash
find src -name "*.c" -exec cat {} \; | wc -l
