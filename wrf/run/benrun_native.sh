#!/bin/bash

export LD_LIBRARY_PATH="/lib64"

ulimit -s unlimited
export I_MPI_PIN_MODE=mpd
export I_MPI_PIN_DOMAIN=auto 
export OMP_NUM_THREADS=180
export KMP_STACKSIZE=62M
export KMP_AFFINITY="balanced,granularity=thread"
export KMP_PLACE_THREADS=60C,3T
export KMP_BLOCKTIME=infinite
export KMP_LIBRARY=turnaround
export WRF_NUM_TILES_X=3
export WRF_NUM_TILES_Y=60
export I_MPI_MIC=1
export I_MPI_FABRIC=shm:ofa
export I_MPI_DEBUG=5

./micmpiexec -n 1 -host mic0 -wdir /data/mic/wrf/WRFV3/test/standard_3.1.1 /data/mic/wrf/WRFV3/test/standard_3.1.1/wrf.exe
