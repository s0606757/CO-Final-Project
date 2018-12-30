`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:33:34 01/04/2016 
// Design Name: 
// Module Name:    CPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CPU(clk,rst,sum,q);

input clk;
input rst;
output [31:0]sum;
output [31:0]q;


wire [31:0]q0,q1,q2,q3,q4;
wire[31:0]q5,q6,q7,q8,q9;
wire [31:0]s3;
wire PCSrc;
wire [31:0]II_Instruction;
wire [31:0]MW_Instruction;
wire MW_RegWrite;
wire [31:0]Reg_WriteData;
wire [31:0]s0;
wire [4:0]MW_Rd;
wire MW_MemtoReg;
wire [31:0]MW_Result;
wire [31:0]MW_ReadData;
wire [31:0]ReadData;
wire [31:0]Result;
wire [31:0]s1;
wire [31:0]ALU_in1;
wire [31:0]ALU_in2;
wire [1:0]ForwardA,ForwardB;
wire EM_MemRead;
wire [31:0]EM_Result;
wire EM_MemtoReg,EM_MemWrite,EM_Branch,EM_ZERO,EM_RegWrite,PC_Write,II_Write;
wire [4:0]EM_Rd;
wire [31:0]EM_PC2_ADD_out,II_PC1_ADD_out,MemData,EM_Readdata2;
wire [31:0]EM_Instruction;



/************************©I¥sInstrFet***************************/

InstrFet IF(
.clk(clk),
.rst(rst),
.PCSrc(PCSrc),
.EM_PC2_ADD_out(EM_PC2_ADD_out),
.II_PC1_ADD_out(II_PC1_ADD_out),
.II_Instruction(II_Instruction),
.PC_Write(PC_Write),
.II_Write(II_Write)
);

/************************©I¥sInstrDec_Execut***************************/
InstrDec_Execu IDEX(
.clk(clk),
.rst(rst),
.II_PC1_ADD_out(II_PC1_ADD_out),
.MW_RegWrite(MW_RegWrite),
.MW_MemData(MW_ReadData),
.MW_Result(MW_Result),
.MW_RD(MW_Rd),
.MW_MemtoReg(MW_MemtoReg),
.II_Instruction(II_Instruction),  
.EM_MemtoReg(EM_MemtoReg),
.EM_RegWrite(EM_RegWrite),
.EM_MemRead(EM_MemRead),
.EM_MemWrite(EM_MemWrite),
.EM_Branch(EM_Branch),
.EM_Result(EM_Result),
.EM_ZERO(EM_ZERO),
.EM_Rd(EM_Rd),
.EM_PC2_ADD_out(EM_PC2_ADD_out),
.EM_Readdata2(EM_Readdata2),
.PC_Write(PC_Write),
.II_Write(II_Write),
.EM_Instruction(EM_Instruction),
.MW_Instruction(MW_Instruction),
.sum(sum),
.Reg_WriteData(Reg_WriteData),
.Result(Result),
.s0(s0),
.s1(s1),
.s3(s3),
.ALU_in1(ALU_in1),
.ALU_in2(ALU_in2),
.ForwardA(ForwardA),
.ForwardB(ForwardB),
.t3(q)
);

/************************©I¥sWriteback***************************/
Mem_Writeback MEWB(
.clk(clk),
.rst(rst),
.EM_MemRead(EM_MemRead),
.EM_Branch(EM_Branch),
.EM_ZERO(EM_ZERO),
.EM_MemWrite(EM_MemWrite),
.EM_Readdata2(EM_Readdata2),
.EM_MemtoReg(EM_MemtoReg),
.EM_RegWrite(EM_RegWrite),
.EM_Result(EM_Result),
.EM_Rd(EM_Rd),
.MW_MemtoReg(MW_MemtoReg),
.MW_RegWrite(MW_RegWrite),
.MW_ReadData(MW_ReadData),
.MW_Result(MW_Result),
.MW_Rd(MW_Rd),
.PCSrc(PCSrc),
.EM_Instruction(EM_Instruction),
.MW_Instruction(MW_Instruction),
.q0(q0),
.q1(q1),
.q2(q2),
.q3(q3),
.q4(q4),
.q5(q5),
.q6(q6),
.q7(q7),
.q8(q8),
.q9(q9),
.ReadData(ReadData)
);

endmodule
