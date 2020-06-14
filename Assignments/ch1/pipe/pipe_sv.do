# 7.5 MIPS pipelined processor simulation do file
### 1�ܰ�: �����̵�
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch1/pipe
### 2�ܰ� : do pipe_sv.do # compile and simulation
# rtl simulation
vlib rtl_work
vmap work rtl_work
vlog 07-mipspipe.sv
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
### 3�ܰ� : quit # modelsim ����
