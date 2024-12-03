#!/bin/bash

find . -name "*.c" -print0 | xargs -0 cat | wc -l
