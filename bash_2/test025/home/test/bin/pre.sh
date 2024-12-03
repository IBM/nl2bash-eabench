#!/bin/bash

cp -p /home/test/bin/delgroup /sbin
groupadd slackers
gpasswd -a test slackers


