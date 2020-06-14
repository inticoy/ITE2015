# MIPS open FPGA simulation do file
### 1단계: 폴더이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch1/MIPSopenFPGA
### 2단계 : do mips_open.do # compile and simulation
vlib work
vlog rtl_up/core/*.v rtl_up/system/*.v rtl_up/system/memories/*.v rtl_up/testbench/*.v +incdir+rtl_up/core +incdir+rtl_up/system
vsim testbench
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
do wave0.do
run -all
### 3단계 : quit # modelsim 종료
