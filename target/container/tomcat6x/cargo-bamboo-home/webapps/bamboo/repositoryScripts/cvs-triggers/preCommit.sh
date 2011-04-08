#!/bin/bash

# all "last directory" tokens are stored in the same directory
mkdir -p /tmp/commit-tokens

# Assume the given directory is the last one, overwritting any existing data.
echo $1 > /tmp/commit-tokens/cvs.$PPID.pid
exit 0