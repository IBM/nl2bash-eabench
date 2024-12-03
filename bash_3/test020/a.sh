#!/bin/bash

curl -s -X POST 'http://murk.sl.cloud9.ibm.com:8080/execute/pwsh' \
    -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer <your_authorization_code>' \
    -d '{
        "test": "test024",
        "version": "pwsh-v1",
        "pwsh": "if (Test-Path \u0022$PathName\u0022) {\n   Write-Host \u0022$PathName\u0022\n} else {\n    Write-Host \u0022$PathName is not valid\u0022\n}\nexit 0 # success"
    }' | jq ".stdout, .stderr" | sed -E 's/\\n/\n/g'
