#Compiling WRF for the Host

##Quick Steps
1. Go into the `WRFV3` directory. 
2. Copy the file `beninstallforhost.sh` into that directory.
3. Next, make a new directory called `custom_configure` and put `configure_host.wrf` into it.
4. Rename `configure_host.wrf` as `configure.wrf`.
5. Check the library directories to make sure that they'll work.
6. Run that script.
7. It will configure. Choose the option for the Intel Xeon Processor (dm+sp)
8. All other options should be default.
9. You're finished!

##Explanation
The `beninstallforhost.sh` script compiles WRF for the host,
with offloading enabled for MKL functions.  Change the variable `OFFLOAD_DEVICES` to 
a comma-separated list of numbers (`0-3`) representing the MICs.

The script simply cleans the source code of all compiled code, then runs the configure script.
After running said script, my build script will copy the `configure.wrf` into the `WRFV3` directory,
as the `configure.wrf` file needed to have a lot of changes that were tedious to make otherwise.

Then, it will run WRF's compile script.  If you just want it to compile `wrf.exe`, you can specify
by changing `compile em_real` to `compile wrf`.  All output will go to the file `compile.log`.

If you look into the `main` directory, you should see `wrf.exe`.  If you do see it, then the build was
successful. Congratulations!

If it was not successful, then you won't see a `wrf.exe`.
