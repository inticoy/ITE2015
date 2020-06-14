# simulation do file
### 1단계 : 폴더 이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch4/project11
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
add wave /clk
add wave /tb/reset
# top module인 tb를 wave이름에 입력해도 되고 안해도 됨
add wave /rising_no
add wave /ta
#add wave /tb하면 error발생 top module tb와 signal tb가 동일한 이름이어서
add wave /tb/tb
# add wave /dut/state는 state 표시가 S0S2로 되어 이상함
# add wave /dut/state[0]는 do실행시 error발생
add wave /dut/state\[0\]
# signal은 hierarchy를 가짐(계층구조)
add wave /tb/dut/nextstate\[0\]
# top module인 tb를 wave이름에 입력해도 되고 안해도 됨
run -all
### 3단계 : quit # modelsim 종료
