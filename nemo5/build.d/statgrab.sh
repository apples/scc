#!/bin/bash
set -e
cd "$NEMO5_LIB_DIR/statgrab/libstatgrab-0.17/"

./configure --disable-shared
make

