`define PERIOD	10
//`define은 C언어의 #define과 같은 기능
// 과제4: MIPSopenFPGA에서 많이 사용
//`define: 593쪽 22.Compiler directive
// ` backquote 발음이 어려워 역따옴표
// 큰따옴표,작은따옴표,역따옴표 => " 쌍따옴표, ' 홑따옴표, ` 역따옴표 

module tb();
  logic clk, reset, ta, tb;
  logic [1:0] la, lb, la_exp, lb_exp;
  int rising_no; // rising clock edge 번호. int: 62쪽 6.11 Integer data type
                 // verilog에는 다양한 data type이 있음
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
  // sequential hw는 rising edge에서만 변화하므로
  // input은 교재 142쪽 그림 3.37과 같이 input은 setup time을 위해
  // rising edge전에 변화하고 rising edge에서는 변화없어야 하기에
  // falling edge에서 변화하는 것으로 함
  // check 시점은 output을 check하기에 그림 3.37과 같이 
  // clock-to-Q propagation delay를 고려하여 rising edge 이후에 check
  
  always @(negedge clk)
    if (~reset) begin // skip during reset
      {ta, tb, la_exp, lb_exp} = testvectors[vectornum];
      #(`PERIOD*6/10); //#(`PERIOD*5/10)는 rising edge임
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
