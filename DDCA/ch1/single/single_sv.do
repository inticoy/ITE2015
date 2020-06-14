# 7.6 MIPS single cycle processor simulation do file
# 1단계 : 폴더 이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch1/single
# 2단계 : do single_sv.do # compile and simulation
# rtl simulation
vlib rtl_work
vmap work rtl_work
# compile
vlog 07-mipssingle.sv 
# simulation
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
add wave -radix hex  /dut/imem/a
add wave -radix hex  /dut/imem/rd
run -all
# 3단계 : quit # modelsim 종료
