# simulation do file
### 1단계 : 폴더 이동
# I cannot use spaces, special characters, or non-English characters 
#   in path names.
# cd D:/PROGRAMMING/SystemVerilog/ITE2015/chapter_4/example_4_5
### 2단계 : do sim.do # compile and simulation
vlib work
vlog tb.sv hw.sv
vsim -t ps work.tb
add wave /d0
add wave /d1
add wave /s
add wave /y
run -all
### 3단계 : quit # modelsim 종료
