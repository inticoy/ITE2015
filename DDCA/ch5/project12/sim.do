# simulation do file
### 1�ܰ� : ���� �̵�
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch5/project12
### 2�ܰ� : do sim.do # compile and simulation
vlib work
# compile
vlog tb.sv ch5-adder.sv
# simulation
vsim -t ps work.tb 
# For changing VSIM(paused)> prompt to Modelsim> prompt
# using abort command
# For changing VSIM 3> prompt to Modelsim> prompt
# using quit -sim command
# waveform setting
add wave /a
add wave /b
add wave /s
run -all
### 3�ܰ� : quit # modelsim ����

