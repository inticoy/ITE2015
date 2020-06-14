// two's complement number에 대한 adder 동작시험
module tb();
  logic [31:0] a,b,s;

  // instantiate device to be tested
  adder #(32) dut(a,b,s);
  
  // apply inputs and check results
  initial
    begin
      a = 32'h00_00_00_01; b = 32'h00_00_00_02;  // 1+2
      #10;
      a = 32'hff_ff_ff_ff; b = 32'h00_00_00_02;  // -1+2
      #10;
      $stop;
    end
endmodule
