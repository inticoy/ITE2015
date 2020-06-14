module tb();
	logic [3:0] a;
	logic y;
	
	//instantiate device to be tested
	xor_4 dut(a,y);
	
	//generate input sequence
	initial
		begin
			a = 4'b0001;
			#10;
			a = 4'b1111;
			#10;
			$stop;
		end
endmodule
