module tb();
  logic [7:0]a;
  logic y;

  // instantiate device to be tested
  and8 dut(a,y);

  // generate input sequence
  initial
    begin
      a = 8'b00000000; 
      #10;
      a = 8'b00001111; 
      #10
	  a = 8'b11000011;
	  #10;
	  a = 8'b11111111;
	  #10;
    end
endmodule
