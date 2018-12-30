`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:41:00 01/04/2016
// Design Name:   CPU
// Module Name:   C:/Xilinx/computer8/CPU_testbench.v
// Project Name:  computer8
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_testbench;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [31:0] sum;
	wire [31:0] q;
  
	CPU uut (
		.clk(clk), 
		.rst(rst), 
		.sum(sum),
		.q(q)
		);
	
	
	always 
	#6 clk=~clk;
	
	// Instantiate the Unit Under Test (UUT)
	initial begin
	// Initialize Inputs
		clk = 1'b1;
		rst = 1'b0;
   	// Wait 100 ns for global reset to finish
		#100;
      #5  rst = 1'b1;
		#100  rst = 1'b0;
		
	// Add stimulus here

	end
	
endmodule

