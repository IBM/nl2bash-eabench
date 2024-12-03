#!/bin/bash
find src \( -name "*.c" -o -name "*.h" \) -exec grep -l TODO {} \;
