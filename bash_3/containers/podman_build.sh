#!/bin/bash

#
# podman build --format docker -t eabench_bash3 -f ./Containerfile --network host
#
podman build -t eabench_bash3 -f bash_3/containers/Containerfile --network host
