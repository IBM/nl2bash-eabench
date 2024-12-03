#!/bin/bash
find . -name \*.py -print0 | xargs -0 sed -i '1 i Line of text here'
