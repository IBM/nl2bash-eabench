#!/bin/bash

( [ "$(echo $1 | rev)" -eq "$1" ] && echo "is" ) || echo "not"

