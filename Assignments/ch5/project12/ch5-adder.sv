// 5.1: adder
// N = 4일때 합성하고 Tech viwer를 보면 4개 ripple carry adder를 볼 수 있음
// Tech viewer의 equation에서 $xor, &and, !not, #or
// 1bit half adder : s = a xor b cout = a and b
// 1bit full adder : s = a xor b xor cin 
//        cout = (a and b) or (a and cin) or (b and cin)
// ~ NOT(tilde) & AND(ampersand) | OR(vertical bar) ^ XOR(caret)

module adder #(parameter N = 4)
              (input  logic [N-1:0] a, b,
               output logic [N-1:0] s);

  assign  s = a + b; // logic 자료형에 대한 + opeator의
                     // operand는 2's complement number
endmodule
