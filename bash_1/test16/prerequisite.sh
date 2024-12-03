#!/bin/bash

for n in {1..5};
do
    nohup python cpu_consumer.py &
done