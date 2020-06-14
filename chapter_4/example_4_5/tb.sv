module tb();
  logic [3:0]d0, d1;
  logic s;
  logic [3:0]y;

  // instantiate device to be tested
  mux2 dut(d0, d1, s, y);

  // generate input sequence
  initial
    begin
      d0 = 4'b1001; d1 = 4'b0110; s = 1; 
      #10;
      d0 = 4'b1001; d1 = 4'b0110; s = 0; 
      #10;
  end
endmodule
