module tb();
  logic a,b,c,y;
  
  // instantiate device to be tested
  example dut(a,b,c,y);

  // generate input sequence
  initial
    begin
      a = 0; b = 0; c= 0;
      #10;
	  a = 1; b =1; c= 1;
	  #10;
    end
endmodule
