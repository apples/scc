#Mode explanations
To start out, I want to describe the various modes that WRF can be run in:
1. "Normal" mode -- this uses the host's processors only.
2. Symmetric mode -- this uses the host's processors and the MICs, treating
the MICs as separate MPI ranks and thus independent nodes in a heterogenous cluster.
3. Native mode -- this uses just the MICs, using the host's processors (technically,
the processor bus only) to merely pass data between the MICs, leaving the host's
processors to do other things.
4. Offload mode -- this uses mostly just the host's processors, with the small added
benefit of being able to offload little chunks (just MKL functions) to the MICs. Not
very beneficial in the majority of cases.

#Running WRF in "Normal" Mode

##Quick Steps
1. Copy 
