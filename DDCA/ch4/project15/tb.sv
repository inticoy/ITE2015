module tb();
	logic a,b,c;
	logic y;
	
	//instantiate device to be tested
	minority dut(a,b,c,y);
	
	//generate input sequence
	initial
		begin
			a = 1'b0; b=1'b0; c=1'b1;
			#10;
			a = 1'b1; b=1'b1; c=1'b0;
			#10;
			$stop;
		end
endmodule
