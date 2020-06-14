module tb();
	logic [31:0] a,b;
	logic [2:0] f;
	logic [31:0] y;
	
	//instantiate device to be tested
	alu32 dut(a,b,f,y);
	
	//generate input sequence
	initial
		begin
			a = 32'h1; b=32'h2; f=3'b111;
			#10;
			a = 32'h2; b=32'h1; f=3'b111;
			#10;
			$stop;
		end
endmodule
