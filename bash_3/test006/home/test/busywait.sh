#!/bin/bash

while( true ); do sleep 10; done 1>/dev/null 2>&1 &
echo $!
