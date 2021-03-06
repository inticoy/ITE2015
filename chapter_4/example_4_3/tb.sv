module tb();
  logic [3:0]a,b,y1,y2,y3,y4,y5;

  // instantiate device to be tested
  gates dut(a,b,y1,y2,y3,y4,y5);

  // generate input sequence
  initial
    begin
      a = 4'b0000; b = 4'b1111; 
      #10;
      a = 4'b0011; b = 4'b1111; 
      #10
	  $stop;
    end
endmodule
