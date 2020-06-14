// 5.1: adder
// N = 4�϶� �ռ��ϰ� Tech viwer�� ���� 4�� ripple carry adder�� �� �� ����
// Tech viewer�� equation���� $xor, &and, !not, #or
// 1bit half adder : s = a xor b cout = a and b
// 1bit full adder : s = a xor b xor cin 
//        cout = (a and b) or (a and cin) or (b and cin)
// ~ NOT(tilde) & AND(ampersand) | OR(vertical bar) ^ XOR(caret)

module adder #(parameter N = 4)
              (input  logic [N-1:0] a, b,
               output logic [N-1:0] s);

  assign  s = a + b; // logic �ڷ����� ���� + opeator��
                     // operand�� 2's complement number
endmodule
