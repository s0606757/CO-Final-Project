`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:42:19 01/08/2016 
// Design Name: 
// Module Name:    Mem_Writeback 
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
module Mem_Writeback(
clk,
rst,
EM_MemRead,
EM_Branch,
EM_ZERO,
EM_MemWrite,
EM_Readdata2,
EM_MemtoReg,
EM_RegWrite,
EM_Result,
EM_Rd,
MW_MemtoReg,
MW_RegWrite,
MW_ReadData,
MW_Result,
MW_Rd,
PCSrc,
EM_Instruction,
MW_Instruction,
q0,
q1,
q2,
q3,
q4,
q5,
q6,
q7,
q8,
q9,
ReadData
);
input clk;
input rst;
input EM_MemRead;
input EM_Branch;
input EM_ZERO;
input EM_MemWrite;
input [31:0]EM_Readdata2;
input EM_MemtoReg;
input EM_RegWrite;
input [31:0]EM_Result;
input [4:0]EM_Rd;
input [31:0]EM_Instruction;

output [31:0]q0,q1,q2,q3,q4,q5,q6,q7,q8,q9;
output reg MW_MemtoReg;
output reg MW_RegWrite;
output reg [31:0]MW_ReadData;
output reg [31:0]MW_Result;
output reg [4:0]MW_Rd;
output reg PCSrc;
output reg [31:0]MW_Instruction;
output reg [31:0]ReadData;


reg [31:0] DataMem [31:0];
reg[31:0]Mem_WriteData;

assign q0=DataMem[16];
assign q1=DataMem[17];
assign q2=DataMem[18];
assign q3=DataMem[19];
assign q4=DataMem[20];
assign q5=DataMem[21];
assign q6=DataMem[22];
assign q7=DataMem[23];
assign q8=DataMem[24];
assign q9=DataMem[25];

/**************************Sequential電路***************************/
always @(posedge clk or posedge rst)
begin
	if (rst) begin
		MW_MemtoReg <= 1'b0;
		MW_RegWrite <= 1'b0;
		MW_ReadData	<= 32'b0;
		MW_Result <= 32'b0;
		MW_Rd	<= 5'b0;
		MW_Instruction<=32'b0;
	end
	else begin
		MW_MemtoReg <= EM_MemtoReg;
		MW_RegWrite <= EM_RegWrite;
		MW_ReadData	<= ReadData;
		MW_Result <= EM_Result;
		MW_Rd <= EM_Rd;	
		MW_Instruction<=EM_Instruction;
	end
end


/*************************Combinational電路****************************/
always@(*)
begin
   PCSrc=EM_ZERO && EM_Branch;
end


/***************記憶體初始值******************/
always@(*)
begin
      if(rst)begin
		   DataMem[1]=32'd1000000;
		   DataMem[2]=32'd3000000;
		   DataMem[3]=32'd5000000;
		   DataMem[4]=32'd7000000;
		   DataMem[5]=32'd9000000;
		   DataMem[6]=32'd11000000;
		   DataMem[7]=32'd13000000;
		   DataMem[8]=32'd15000000;
		   DataMem[9]=32'd17000000;
		   DataMem[10]=32'd19000000;
			
			DataMem[0]=32'd0;
			DataMem[11]=32'd0;
			DataMem[12]=32'd0;
			DataMem[13]=32'd0;
			DataMem[14]=32'd0;
			DataMem[15]=32'd0;
			DataMem[16]=32'd0;
			DataMem[17]=32'd0;
			DataMem[18]=32'd0;
			DataMem[19]=32'd0;
			DataMem[20]=32'd0;
			DataMem[21]=32'd0;
			DataMem[22]=32'd0;
			DataMem[23]=32'd0;
			DataMem[24]=32'd0;
			DataMem[25]=32'd0;
			DataMem[26]=32'd0;
			DataMem[27]=32'd0;
			DataMem[28]=32'd0;
			DataMem[29]=32'd0;
			DataMem[30]=32'd0;
			DataMem[31]=32'd0;
		end
		else begin
		
      if(EM_MemWrite && ~(EM_MemRead))
		   DataMem[EM_Result/4] = Mem_WriteData;

		if(EM_MemRead && ~(EM_MemWrite))
		   ReadData = DataMem[EM_Result/4];
      
		end
end

/***************控制Mem寫入時間*****************/
always@(negedge clk)
begin
   Mem_WriteData<=EM_Readdata2;
end


endmodule
