#!/bin/bash
find . -name "*.py" | xargs sed -i '1i #!/usr/bin/python3'


