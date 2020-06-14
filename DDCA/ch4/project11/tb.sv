`define PERIOD	10
//`define�� C����� #define�� ���� ���
// ����4: MIPSopenFPGA���� ���� ���
//`define: 593�� 22.Compiler directive
// ` backquote ������ ����� ������ǥ
// ū����ǥ,��������ǥ,������ǥ => " �ֵ���ǥ, ' Ȭ����ǥ, ` ������ǥ 

module tb();
  logic clk, reset, ta, tb;
  logic [1:0] la, lb, la_exp, lb_exp;
  int rising_no; // rising clock edge ��ȣ. int: 62�� 6.11 Integer data type
                 // verilog���� �پ��� data type�� ����
  logic [31:0] vectornum, errors;
  logic [5:0]  testvectors[10:0];

  // instantiate device to be tested
  trafficFSM dut(clk, reset, ta, tb, la, lb);
  
  // generate clock
  always 
      #(`PERIOD/2) clk = ~clk;

  // count rising edge of clock
  always @(posedge clk)
      rising_no ++;

  // reset activate and deactive 
  initial
    begin
      clk =0;
      reset = 1; 
      rising_no =0;
      #(`PERIOD*16/10); // after 2 rising edge + 1/10cycle
      reset = 0; 
    end

  // at start of test, load vectors
  initial
    begin
      $readmemb("example.tv", testvectors);
      vectornum = 0; errors = 0;
    end

  // apply test vectors on negedge of clk
  // check results on posedge + 1/10 period
  // sequential hw�� rising edge������ ��ȭ�ϹǷ�
  // input�� ���� 142�� �׸� 3.37�� ���� input�� setup time�� ����
  // rising edge���� ��ȭ�ϰ� rising edge������ ��ȭ����� �ϱ⿡
  // falling edge���� ��ȭ�ϴ� ������ ��
  // check ������ output�� check�ϱ⿡ �׸� 3.37�� ���� 
  // clock-to-Q propagation delay�� ����Ͽ� rising edge ���Ŀ� check
  
  always @(negedge clk)
    if (~reset) begin // skip during reset
      {ta, tb, la_exp, lb_exp} = testvectors[vectornum];
      #(`PERIOD*6/10); //#(`PERIOD*5/10)�� rising edge��
      if (la !== la_exp) begin  // check result
        $display("Error: inputs = %b", {ta, tb});
        $display("  outputs = %b (%b expected)",la, la_exp);
        errors = errors + 1;
      end
      vectornum = vectornum + 1;
      if (testvectors[vectornum] === 6'bx) begin 
	$display("");
        $display("  [Result] %d tests completed with %d errors", 
	           vectornum, errors);
	$display("");
        $stop;
      end
    end
endmodule
