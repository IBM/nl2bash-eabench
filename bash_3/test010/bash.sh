#!/bin/bash
#
# Write a bash script which converts its 32-bit argument from hex to BCD.
#
# 32-bit number: we'll need 4*ceil(32/3) bits or 44 bits
#
# This code expanded to handle up to 48-bit input
#  - 4*ceil(48/3) is 64 bits
#

function add() {
    local bcd=$1
    for(( i=0; i<16; i++ ))
    do
        n=$(( 4*i ))
        bcd=$(( ((bcd >> $n) & 0xF) < 5 ? bcd : (bcd + (3 << $n)) ))
    done
    echo $bcd
}

# Check if the argument is a 32-bit hexadecimal number
hex=$1
hex=${hex/#0X/}
hex=${hex/#0x/}
if [[ $hex =~ ^[0-9A-Fa-f]*$ ]]; then
    hex=0x$hex
    if (( $hex < (1<<48) ))
    then
        bcd=0
        for(( i=0; i<47; i++ ))
        do
            bcd=$(( bcd << 1 | (hex>>47) & 1 )); hex=$(( hex << 1 ))
            #printf "%2d: %X --> " $i $bcd
            bcd=$(add $bcd)
            #printf "%X\n" $bcd
        done
        bcd=$(( bcd << 1 | (hex>>47) & 1 ))
        # Print as hex but will look like decimal
        printf "%X\n" $bcd
    else
        printf "%X is too large\n" $hex
    fi
else
  # Print an error message if the argument is not a 32-bit hexadecimal number
  echo "Error: $1 is not a 32-bit hexadecimal number."
fi
