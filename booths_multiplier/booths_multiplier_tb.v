// Code your testbench here
// or browse Examples
module booths_multiplier_tb();
  reg reset, start, clk;
  reg signed[7:0] M, Q;
  
  wire signed [15:0] Acc;
  wire valid;
  
  booths_multiplier DUT(clk, reset, start, M, Q, valid, Acc);
  
  task reset_dut();
    begin
      @(negedge clk)
      	reset <= 1'b0;
      @(negedge clk)
      	reset <= 1'b1;
    end
  endtask
  
  task start_dut(input signed[7:0] Multiplicand, Multiplier);
    begin
      @(negedge clk)
      	start <= 1'b1;
      	M <= Multiplicand;
        Q <= Multiplier;
      repeat(9)
        @(negedge clk);
      start <= 1'b0;
    end
  endtask
  
  initial begin
    clk = 1'b0;
    forever
      #5 clk = ~clk;
  end
  
  initial begin
    reset_dut();
    start_dut(8'd45, 8'd10);
    start_dut(8'd56, 8'd79);
    start_dut(8'd127, 8'd127);
    start_dut(-8'd45, 8'd10);
    $finish;
  end
   
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
    $monitor($time,": Acc = %0d , valid = %b", Acc, valid);
  end
  
endmodule
