 module and8(input logic [7:0]a,
          output logic y);
  assign y = &a;
  // same as y = a[7] & a[6] ... & a[0];
endmodule
