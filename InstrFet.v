`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// Create Date:    09:34:55 01/04/2016 
// Design Name: 
// Module Name:    InstrFet 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
// Dependencies: 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//////////////////////////////////////////////////////////////////////////////////
module InstrFet(
clk,
rst,
PCSrc,
EM_PC2_ADD_out,
II_PC1_ADD_out,
II_Instruction,
PC_Write,
II_Write
);

input clk;
input rst;
input PCSrc;
input [31:0]EM_PC2_ADD_out;
input PC_Write;
input II_Write;

output reg [31:0]II_PC1_ADD_out;
output reg [31:0]II_Instruction;

reg [31:0]PC_out;
reg [31:0]PC_in;
reg [31:0]Insaddr;

/*******************************************************Sequential電路****************************************************************/
always@(posedge clk or posedge rst)
begin 
   if(rst) begin
	   PC_out<=32'b0;
		II_Instruction<=32'b0;
      II_PC1_ADD_out<=32'b0;
	end
	else begin
	   if(PC_Write)
		   PC_out<=PC_in;
		else
		   PC_out<=PC_out;
			
		if(II_Write)begin
         II_Instruction<=Insaddr;
			II_PC1_ADD_out<=PC_out+32'd4;
		end
		else begin
		   II_Instruction<=II_Instruction;
		   II_PC1_ADD_out<=II_PC1_ADD_out;
	   end
	end
end



/*******************************************************Combiantional電路****************************************************************/
always@(PCSrc or PC_out or EM_PC2_ADD_out)
begin 
   case(PCSrc)
	   1'b0:PC_in=PC_out+32'd4;
		1'b1:PC_in=EM_PC2_ADD_out;
	endcase
end



/********************************************************Final指令****************************************************************************/

always@(*)
begin
   case(PC_out/4)
	   32'd0:Insaddr=32'b000000_00000_00000_10010_00000_100000;//add $s2 , $zero , $zero 
      32'd1:Insaddr=32'b000000_00000_00000_01000_00000_100000;//add $t0 , $zero , $zero  
      32'd2:Insaddr=32'b100011_10000_10011_0000000000000000;//LOOP:lw $s3 , 0($s0)
		32'd3:Insaddr=32'b000000_00000_00000_00000_00000_000000;
      32'd4:Insaddr=32'b000000_00000_00000_00000_00000_000000;
		32'd5:Insaddr=32'b000000_10010_10011_10010_00000_100000;//add $s2 , $s2 , $s3 
		32'd6:Insaddr=32'b000000_10010_01000_10011_00000_100010;//sub $s3 , $s2 , $t0  
		32'd7:Insaddr=32'b001000_01000_01000_0000000000000001;//addi $t0 , $t0 , 1  
		32'd8:Insaddr=32'b001000_10000_10000_0000000000000100;//addi $s0 , $s0 , 4 
		32'd9:Insaddr=32'b101011_10001_10011_00000_00000_000000;//sw $s3 , 0($s1)   
		32'd10:Insaddr=32'b001000_10001_10001_0000000000000100;//addi $s1 , $s1 , 4  
		32'd11:Insaddr=32'b001000_00000_10011_0000000000001010;//addi $s3 , $zero , 10
		32'd12:Insaddr=32'b000101_01000_10011_1111_1111_1111_0101;//bne $t0 , $s3 , Loop  
		
/********************************************************讀取指令****************************************************************************/	
		32'd16:Insaddr=32'b100011_10100_01011_00000_00000_000000;//lw  $t3 , 0($s4) 讀取q[0]
		32'd19:Insaddr=32'b100011_10100_01011_00000_00000_000100;//lw  $t3 , 4($s4) 讀取q[1]
		32'd22:Insaddr=32'b100011_10100_01011_00000_00000_001000;//lw  $t3 , 8($s4) 讀取q[2]
		32'd25:Insaddr=32'b100011_10100_01011_00000_00000_001100;//lw  $t3 , 12($s4) 讀取q[3]
		32'd28:Insaddr=32'b100011_10100_01011_00000_00000_010000;//lw  $t3 , 16($s4) 讀取q[4]
		32'd31:Insaddr=32'b100011_10100_01011_00000_00000_010100;//lw  $t3 , 20($s4) 讀取q[5]
		32'd34:Insaddr=32'b100011_10100_01011_00000_00000_011000;//lw  $t3 , 24($s4) 讀取q[6]
		32'd37:Insaddr=32'b100011_10100_01011_00000_00000_011100;//lw  $t3 , 28($s4) 讀取q[7]
		32'd40:Insaddr=32'b100011_10100_01011_00000_00000_100000;//lw  $t3 , 32($s4) 讀取q[8]
		32'd43:Insaddr=32'b100011_10100_01011_00000_00000_100100;//lw  $t3 , 36($s4) 讀取q[9]
		
      default:Insaddr=32'b000000_00000_00000_00000_00000_000000;
	endcase
end


endmodule

