#!/bin/bash
(
    cd $(dirname $0)
    docker build -t eabench_bash2 .
)
