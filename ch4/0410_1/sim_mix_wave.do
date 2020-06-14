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
run -all
### VSIM> 프롬프트로 변경됨
### 3단계: waveform보려는 신호 선택
### 4단계: restart -f
### 5단계: run -all
### 6단계 : quit # modelsim 종료

