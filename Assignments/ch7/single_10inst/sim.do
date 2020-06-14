# 7.6 MIPS single cycle processor simulation do file
### 1단계 : 폴더 이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch7/single_10inst
### 2단계 : do single_sv.do # compile and simulation
vlib work
# compile
vlog single_10inst.sv 
# simulation
vsim -t ps work.tb 
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
# waveform setting
add wave /clk
add wave /reset
add wave /rising_no
add wave -divider {state element}
add wave -radix hex  /dut/mips/dp/pc
add wave -radix hex  /dut/imem/RAM
add wave -radix hex  /dut/mips/dp/rf/rf
add wave -radix hex  /dut/dmem/RAM
add wave -divider {temp signal}
add wave -

run -all
### 3단계 : quit # modelsim 종료
