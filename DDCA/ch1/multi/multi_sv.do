# 7.4 MIPS multicycle processor simulation do file
### 1단계: 폴더이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch1/multi
### 2단계 : do multi_sv.do # compile and simulation
# rtl simulation
vlib rtl_work
vmap work rtl_work
vlog 07-mipsmulti.sv
vsim -t ps work.testbench
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
# waveform setting
add wave /clk
add wave /reset
add wave -radix dec  /writedata
add wave -radix dec  /dataadr
add wave -radix bin  /memwrite
add wave -radix hex  /dut/mem/a
add wave -radix hex  /dut/mem/rd
run -all
### 3단계 : quit # modelsim 종료
