# mipstest.asm
# David_Harris@hmc.edu, Sarah_Harris@hmc.edu 31 March 2012
#
# Test the MIPS processor.
# 10 subset of full MIPS instruction set
# add(1), sub(2), and(3), or(4), slt(5), lw(6), sw(7), beq(8), addi(9), j(10)
# If successful, it should write the value 7 to address 84
# QtSpim에서 실행하면 80번지 write/read시 exception발생
# mipstest_app.asm으로 변경필요
#
# Rom version의 경우
# 교재 336page 그림 6.31에서
# text segment : 0x0 ~
# global data segment : 0x0 ~ 
#
# 교재 373page에서 Real MIPS에서는
# PC to 0xbfc0_0000 on reset

# 	AssemblyCode 	Description 		Address MachineCode
main: 	addi $2, $0, 5 	#L1: initialize $2 = 5 	 0 20020005
	addi $3, $0, 12 #L2: initialize $3 = 12  4 2003000c
	addi $7, $3, -9 #L3: initialize $7 = 3 	 8 2067fff7
	or $4, $7, $2 	#L4: $4 = (3 or 5) = 7 	 c 00e22025
	and $5, $3, $4 	#L5: $5 = (12 and 7)=4  10 00642824
	add $5, $5, $4 	#L6: $5 = 4 + 7 = 11    14 00a42820
	beq $5, $7, end #L7: shouldn't be taken 18 10a7000a
	slt $4, $3, $4 	#L8: $4 = 12 < 7 = 0 	1c 0064202a
	beq $4, $0, around #L9: should be taken 20 10800001
	addi $5, $0, 0 	#L10: shouldn't happen 	24 20050000
around: slt $4, $7, $2 	#L11: $4 = 3 < 5 = 1 	28 00e2202a
	add $7, $4, $5 	#L12: $7 = 1 + 11 = 12 	2c 00853820
	sub $7, $7, $2 	#L13: $7 = 12 - 5 = 7 	30 00e23822
	sw $7, 68($3) 	#L14: [80] = 7 		34 ac670044
	lw $2, 80($0) 	#L15: $2 = [80] = 7 	38 8c020050
	j end 		#L16: should be taken 	3c 08000011
	addi $2, $0, 1 	#L17: shouldn't happen 	40 20020001
end: 	sw $2, 84($0) 	#L18: write mem[84] = 7 44 ac020054
