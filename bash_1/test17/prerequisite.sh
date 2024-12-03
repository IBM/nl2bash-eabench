#!/bin/bash

for n in {1..5};
do
    nohup python mem_consumer.py &
done