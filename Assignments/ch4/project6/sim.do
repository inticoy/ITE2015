#simulation do file
### 1단계: 폴더 이동
#I cannot use spaces, special characters, or non-English characters
#	in path names.
# cd C:/DDCA/ch4/project6
### 2단계: do sim.do #compile and simulation
vlib work
vlog tb.sv hw.sv
vsim -t ps work.tb
add wave /a
add wave /y
run -all