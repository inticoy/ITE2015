# simulation do file
### 1�ܰ� : ���� �̵�
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd C:/DDCA/ch4/project11
### 2�ܰ� : do sim.do # compile and simulation
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
# top module�� tb�� wave�̸��� �Է��ص� �ǰ� ���ص� ��
add wave /rising_no
add wave /ta
#add wave /tb�ϸ� error�߻� top module tb�� signal tb�� ������ �̸��̾
add wave /tb/tb
# add wave /dut/state�� state ǥ�ð� S0S2�� �Ǿ� �̻���
# add wave /dut/state[0]�� do����� error�߻�
add wave /dut/state\[0\]
# signal�� hierarchy�� ����(��������)
add wave /tb/dut/nextstate\[0\]
# top module�� tb�� wave�̸��� �Է��ص� �ǰ� ���ص� ��
run -all
### 3�ܰ� : quit # modelsim ����
