// ~:NOT &:AND |:OR 
module hw(input logic a, b,
          output logic x,y,z);
  assign x = ~a ;
  assign y = a & b;
  assign z = a | b;
endmodule
