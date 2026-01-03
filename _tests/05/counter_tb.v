/*
* counter_tb.v -- Testbench for Simple Digital Counter
*
* (c) 2021-2025 Harald Pretl (harald.pretl@jku.at)
* Johannes Kepler University Linz, Department for Integrated Circuits
*/

`timescale 1ns/1ps

module counter_tb;

  parameter WIDTH = 8;

  reg clk_i;
  reg reset_i;
  wire [WIDTH-1:0] out_o;

  // Instantiate the counter
  counter #(.WIDTH(WIDTH)) dut (
    .clk_i(clk_i),
    .reset_i(reset_i),
    .out_o(out_o)
  );

  // Clock generation
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
  end

  // Test sequence
  initial begin
    $display("Starting counter testbench...");
    reset_i = 1;
    #20;
    reset_i = 0;
    #500;
    $display("Counter value: %d", out_o);
    $display("Test completed successfully!");
    $finish;
  end

endmodule
