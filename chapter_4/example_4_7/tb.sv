module tb();
  logic a, b, cin, s, cout;
  
  // instantiate device to be tested
  fulladder dut(a,b,cin,s,cout);

  // generate input sequence
  initial
    begin
      a = 0; b = 0; cin = 0; 
      #10;
	  a = 1; b = 0; cin = 1;
	  #10;
	  a = 0; b = 1; cin = 0; 
	  #10;
	  a = 1; b = 1; cin = 1; 
	  #10;
    end
endmodule
