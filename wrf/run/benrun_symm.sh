#!/bin/bash

ulimit -s unlimited

export I_MPI_MIC=enable
export I_MPI_FABRIC=shm:ofa
export I_MPI_DEBUG=5
export I_MPI_PIN_MODE=mpd
export I_MPI_PIN_DOMAIN=auto

source /opt/intel/impi/4.1.0/bin/mpivars.sh
source /opt/intel/ics/bin/compilervars.sh intel64
source /opt/intel/ics/bin/ifortvars.sh intel64
source /opt/intel/ics/composer_xe_2013.1.117/mkl/bin/intel64/mklvars_intel64.sh

export OMP_NUM_THREADS=2
export KMP_LIBRARY=turnaround
export KMP_BLOCKTIME=infinite
export KMP_STACKSIZE=32M
export OMP_SCHEDULE=DYNAMIC
export I_MPI_MIC_POSTFIX=.mic

rm rsl.*
./micmpiexec -n 12 -machinefile /data/mic/wrf/WRFV3/test/standard_symm_3.1.1/machines -wdir /data/mic/wrf/WRFV3/test/standard_symm_3.1.1 /data/mic/wrf/WRFV3/test/standard_symm_3.1.1/wrf.exe
