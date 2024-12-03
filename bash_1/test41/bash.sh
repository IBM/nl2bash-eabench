#!/bin/bash

comm -3 <(sort file1.txt | uniq) <(sort file2.txt | uniq) | wc -l
