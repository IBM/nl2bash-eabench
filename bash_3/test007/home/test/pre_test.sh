#!/bin/bash
#
# Any "warm up" commands to set the stage for bash.sh
#   - eg, spin up a busy-wait task so a ps command sees 100% CPU utilization
#
groupadd disney
adduser mickey -G disney
adduser minnie -G disney

for(( i=0; i<10; i++ ))
do
    sudo -i -u mickey touch mickey_data.$i
done

for(( i=0; i<11; i++ ))
do
    sudo -i -u minnie touch minnie_data.$i
done

for(( i=5; i<10; i++ ))
do
    sudo -i -u mickey chgrp disney /home/mickey/mickey_data.$i
    sudo -i -u minnie chgrp disney /home/minnie/minnie_data.$i
done
