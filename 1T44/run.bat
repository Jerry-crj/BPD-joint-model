rmdir  /S/Q  output
rmdir  /S/Q  all 
mkdir output
del  *.plt
REM for /f %%p in (dirList.txt) do mkdir %%p
set  core=10
mpiexec   -np  %core%  OpenSeesMP   main.tcl
type  output\tip\tip*.out>pred.out
pause
