module tb();
  logic a,b,x,y,z;

  // instantiate device to be tested
  hw dut(a,b,x,y,z);
  
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
      $stop;
    end
endmodule
