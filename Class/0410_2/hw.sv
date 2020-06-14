// ~:NOT &:AND |:OR 
module hw(input logic a, b,
          output logic x,y,z);
  assign x = ~a ;
  assign y = a & b;
  z = a | b;
endmodule
