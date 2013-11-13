#1.0 Mode explanations
1. "Normal" mode -- this uses the host's processors only.
2. Symmetric mode -- this uses the host's processors and the MICs, treating
the MICs as separate MPI ranks and thus independent nodes in a heterogenous cluster.
3. Native mode -- this uses just the MICs, using the host's processors (technically,
the processor bus only) to merely pass data between the MICs, leaving the host's
processors to do other things.
4. Offload mode -- this uses mostly just the host's processors, with the small added
benefit of being able to offload little chunks (just MKL functions) to the MICs. Not
very beneficial in the majority of cases.

#2.0 Running WRF in All Modes

##2.1 Quick Steps
1. Make a new directory for your run in the `test` folder. (ex. `test/foo`)
2. Copy all of the included input files into that directory. (ex. `test/foo/wrfinput*`)
3. Make a soft link to `wrf.exe` into the directory you created. (ex. `ln -s ../../main/wrf.exe .`)
4. Check for a file named `RRTM_DATA`.  Copy or link it into your run directory. (ex. `ln -s ../../run/RRTM_DATA .`)
5. Copy the files in the `bin` folder of this readme's directory to your run directory. (ex. `micssh micmpiexec`)
6. Check your namelist.input file. This is the file that regulates the entire WRF run.
7. Make a new file called `machines` and list the hostnames of the computers you want to run it on.
8. Run the `benrun_*.sh` script.
9. If it stops quickly, check the file `rsl.error.0000` for errors. They should be easy to understand.
10. If it runs successfully, you should see a `wrfoutput*` file in the directory. Success!

##2.2 Explanation
This is a general guide to running WRF, but the methods of running WRF are all extremely similar.

The file `RRTM_DATA` is a data file used by WRF that can be used for each and every run, but it complains
if you do not include it in the directory that you're running WRF in.  

If you are given WRF input that does not include files that begin with `wrfinput`, then you have been given 
input for one of the other executables, namely `real.exe` or `ideal.exe`.  If that is the case, then you need to 
first make a soft link to the appropriate executable (`real.exe` for real-world runs, and `ideal.exe` for quick,
theoretical runs), and then run that executable before running wrf.exe in the directory.
For the competition, we will be given `wrfinput*` files, so that we will not even need `real.exe` or `ideal.exe` to be
compiled.

##2.3 Notes for Symmetric Mode
If you are attempting to run WRF in Symmetric Mode, then you need to do things a bit differently. Of course, you're going
to have to use the script `benrun_symm.sh`, but aside from that you'll have to compile WRF for both the host and the MIC
separately. Put the `wrf.exe` compiled for the MIC in a location that is accessible by the MIC (On Smokey that would be
somewhere in `/data/mic`), and make a soft link to it called `wrf.exe.mic` in the directory that you'd like to run WRF in.
Name the `wrf.exe` compiled for the host normally (`wrf.exe`), and obviously make a link for that as well.

Now if you look at `benrun_symm.sh`, it has a line setting `I_MPI_MIC_POSTFIX` to `.mic`. You may change this as you desire.

It is also extremely recommended that you change `OMP_NUM_THREADS` as you see fit, as this is the number of OpenMP threads
that each MIC gets, and, as the MICs use OpenMP threads quite heavily, it affects performance a very great deal.  Changing
the number of MPI ranks also does some good, but the general rule is that you give only one or two ranks to each MIC.

In the `machines` file, you should list the hostnames of the MICs that you want to run it on as well as the hostnames of the hosts.
To refer to a MIC on another host, use `hostname_micname`, so that a host named `smokey2` would have a MIC, as seen by a certain
`smokey1`, as `smokey2-mic0`.  You may also arbitrarily include the main host's name, such as in `smokey1_mic0`.

##2.4 Notes for Native Mode
This is the fastest mode available if you need to use your hosts' processors for other things. It is nearly identical to the setup of
Symmetric mode, except you exclude the names of the hosts in your `machines` file.  Data travelling between MICs will need to go through
the CPU buses of the hosts, and I assume that this means that performance for the CPUs will be slightly decreased.

##2.5 Notes for Offload Mode
This is the mode that you will most likely be running instead of Normal mode, where the MICs will take just a little bit of the processing
from the hosts' processors if they see fit. Of course, you can manually specify functions to offload to the MICs, but the automatic offload
mode is very good at detecting if the overhead is worth the possible performance gain. On most runs, the MICs will barely even run anything,
and you're usually better off running in either Native or Symmetric mode. Use only if you have other things going on on the MICs.
