module tb();
  logic clk;
  logic a,b,x,y,z;

  // instantiate device to be tested
  hw dut(a,b,x,y,z);
  
  // generate clock
  always
    begin
      clk = 1; #5; clk = 0; #5;
    end
  
  // generate input sequence
  initial
    begin
      a = 0; b = 0; 
      #10;
      a = 0; b = 1; 
      #10;
      a = 1; b = 0; 
      #10;
      a = 1; b = 1; 
      #10;
      // $stop;
    end
endmodule
