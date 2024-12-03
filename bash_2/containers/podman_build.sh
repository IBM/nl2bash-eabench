#!/bin/bash
#
# podman build --format docker -t ubi:nl2bash_eabench -f ./Containerfile --network host
#
podman build -t eabench_bash2 -f bash_2/containers/Containerfile --network host
