module tb();
  logic [3:0]a;
  logic en;
  tri y;
  
  // instantiate device to be tested
  tristate dut(a,en,y);

  // generate input sequence
  initial
    begin
      a = 4'b0000; en = 0;
      #10;
	  a = 4'b1010; en = 1;
	  #10;
    end
endmodule
