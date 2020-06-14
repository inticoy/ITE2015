module tb();
  logic [3:0]a,y;

  // instantiate device to be tested
  inv dut(a,y);

  // generate input sequence
  initial
    begin
      a = 4'b0000; 
      #10;
      a = 4'b0011; 
      #10
	  $stop;
    end
endmodule
