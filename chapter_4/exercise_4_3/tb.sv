module tb();
  logic [3:0]a,y;

  // instantiate device to be tested
  fxor dut(a,y);

  // generate input sequence
  initial
    begin
      a = 4'b0000; 
      #10;
	  a = 4'b0001;
	  #10;
      a = 4'b0011; 
      #10;
	  a = 4'b0111;
	  #10;
	  a = 4'b1111;
	  #10;
	  $stop;
    end
endmodule
