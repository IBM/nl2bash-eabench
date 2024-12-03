#FROM python:3
FROM docker.io/library/python:3@sha256:a31cbb4db18c6f09e3300fa85b77f6d56702501fcb9bdb8792ec702a39ba6200

WORKDIR /app

COPY run.sh run.sh

ENTRYPOINT [ "bash", "run.sh" ]
