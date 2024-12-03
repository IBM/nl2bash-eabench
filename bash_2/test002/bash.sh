#!/bin/bash
ps -eo pcpu,pid,cmd k -pcpu | head -10

