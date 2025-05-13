
wipe ;

logFile screen.out
model basic -ndm 3 -ndf 6

set pid [getPID]
set np [getNP]

source material.tcl

set dt 0.02
set tol 5.0e-2

puts "[expr $pid]!!!!!!!!!!!!!!!!!!"

source "node[expr $pid].tcl"	
source "fix[expr $pid].tcl"
source "element[expr $pid].tcl"
source "recordInitNodeCoord[expr $pid].tcl"

if {$pid == 5} {
	source load5.tcl
}

file mkdir "./output/recordEachFrameNodeDispl[expr $pid]"
file mkdir "./output/recordEachFrameStrainStress[expr $pid]"
file mkdir "./output/recordEachFrameSteelForce[expr $pid]"

constraints Transformation;     				
numberer ParallelPlain
system Mumps -ICNTL14 300
test NormDispIncr  $tol  5	 1	
algorithm Newton;					
integrator LoadControl  0.1
analysis Static	
analyze 10

loadConst -time  0

source divideStepAnalysis.tcl

if {$pid == 9} {
	source load9.tcl
}
if {$pid == 5} {
	source load15.tcl
}

analysis Static	

for {set times 1} {$times <= 10000} {incr times} {
	test NormDispIncr  $tol  4	 1	
	integrator LoadControl  $dt
	algorithm Newton;					
	analysis Static	
	set ok [analyze 1]
	if {$ok != 0} {
		divideStepAnalysis   $dt    10    $tol
	} else {
        if {$pid == 9} {
            source "recorder.tcl"
        }
    }
	source "recordEachFrameNodeDispl[expr $pid].tcl"
	source "recordEachFrameStrainStress[expr $pid].tcl"
	source "recordEachFrameSteelForce[expr $pid].tcl"
}

wipe

