#!/bin/bash

cd() {
    builtin cd "$@" && ls
}
