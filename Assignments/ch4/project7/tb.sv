//`define�� C����� #define�� ���� ���
//sv-2009.pdf�� 593��
`define PERIOD	10

module tb();
  logic clk, reset, ta, tb;
  logic [1:0] la, lb;
  int rising_no; // rising clock edge ��ȣ. int datatype���.sv-2009.pdf�� 62�� 
                 // verilog���� �پ��� data type�� ����

  // instantiate device to be tested
  trafficFSM dut(clk, reset, ta, tb, la, lb);
  
  // generate clock
  always 
      #(`PERIOD/2) clk = ~clk;

  // count rising edge of clock
  always @(posedge clk)
      rising_no ++;

  // generate reset and deactive on falling edge of clock
  // after reset, generate input sequence
  initial
    begin
      clk =0;
      reset = 1; 
      rising_no =0;
      ta = 1; tb=0; // go to S0
      @(negedge clk); // clk�� falling edge�� ��ٸ� sv.pdf�� 293��
      @(negedge clk);
      reset = 0; 
      @(negedge clk);
      ta = 0; tb=1; // go to S1
      @(negedge clk); // will go to S2
      @(negedge clk);
      ta = 0; tb=0; // go to S3
      @(negedge clk); // will go to S0
      @(negedge clk);
      $stop;
    end
endmodule
