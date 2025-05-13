set filename "./output/tips.out" 
set file [open $filename a+ ]
puts $file   "[nodeDisp 14712 3]  [nodeUnbalance 14712 3]  [lindex [eleResponse	6511	force] 2]"
close $file
