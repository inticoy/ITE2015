# simulation do file
### 1단계 : 폴더 이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch4/0410_1
### 2단계 : do sim.do # compile and simulation
vlib work
# compile
vlog tb.sv hw.sv
# simulation
vsim -t ps work.tb 
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
# waveform setting
add wave /a
add wave /b
add wave /x
add wave /y
add wave /z
run -all
### 3단계 : quit # modelsim 종료

