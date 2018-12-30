`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:38:40 01/04/2016 
// Design Name: 
// Module Name:    InstrDec_Execu 
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
module InstrDec_Execu(
clk,
rst,
II_PC1_ADD_out,
MW_RegWrite,
MW_MemData,
MW_Result,
MW_RD,
MW_MemtoReg,
II_Instruction,  
EM_MemtoReg,
EM_RegWrite,
EM_MemRead,
EM_MemWrite,
EM_Branch,
EM_Result,
EM_ZERO,
EM_Rd,
EM_PC2_ADD_out,
EM_Readdata2,
PC_Write,
II_Write,
EM_Instruction,
MW_Instruction,
sum,
Reg_WriteData,
Result,
s0,
s1,
s3,
ALU_in1,
ALU_in2,
ForwardA,
ForwardB,
t3
);


input clk;
input rst;
input [31:0]II_PC1_ADD_out;
input MW_RegWrite;
input [31:0]MW_MemData;
input [31:0]MW_Result;
input [4:0]MW_RD;
input MW_MemtoReg;
input [31:0]II_Instruction;
input [31:0]MW_Instruction;

output reg [31:0]Reg_WriteData;
output reg PC_Write;
output reg II_Write;

output [31:0]sum;
output [31:0]s0,s1,s3;
output [31:0]t3;

reg MemtoReg;
reg RegWrite;
reg MemWrite;
reg MemRead;
reg Branch;
reg [1:0]ALUOP;
reg RegDst;
reg IE_MemtoReg;
reg IE_RegWrite;
reg IE_MemWrite;
reg IE_MemRead;
reg IE_Branch;
reg [1:0]IE_ALUOP;
reg IE_RegDst;
reg [31:0]IE_PC1_ADD_out;	
reg [31:0]IE_ALU_in1;
reg [31:0]IE_ALU_in2;
reg [31:0]IE_Signextend_out;	
reg [31:0]IE_Instruction;
reg [31:0]REG[20:0];
reg [31:0]Readdata1;
reg [31:0]Readdata2;
reg [31:0]Signextend_out;
reg Control_mux;

assign sum=REG[18];
assign s0=REG[16];
assign s1=REG[17];
assign s3=REG[19];
assign t3=REG[11];        
/*************************/
output reg EM_MemtoReg;
output reg EM_RegWrite;
output reg EM_MemRead;
output reg EM_MemWrite;
output reg EM_Branch;
output reg [31:0]EM_Result;
output reg EM_ZERO;
output reg [4:0]EM_Rd;
output reg [31:0]EM_PC2_ADD_out;
output reg [31:0]EM_Readdata2;
output reg [31:0]ALU_in1;
output reg [31:0]ALU_in2;
output reg [31:0]Result;
output reg [1:0]ForwardA,ForwardB;
output reg [31:0]EM_Instruction;

reg [3:0]ALU_operation_control;
reg ZERO;
reg [4:0]Rd;
reg [31:0]PC2_ADD_in2;
reg [31:0]PC2_ADD_out;

//--parameter declaration
parameter AND     = 4'b0000;
parameter OR      = 4'b0001;
parameter ADD     = 4'b0010;
parameter SUB     = 4'b0110;
parameter SLT     = 4'b0111;
parameter NOR     = 4'b1100;
parameter SLL     = 4'b0011;
parameter XOR     = 4'b0100;


/****************************************************ID Sequential電路****************************************************************/
always @(posedge clk or posedge rst)
begin
	if(rst) begin
	   IE_MemtoReg<=1'b0;
      IE_RegWrite<=1'b0;
      IE_MemWrite<=1'b0;
      IE_MemRead<=1'b0;
      IE_Branch<=1'b0;
      
      IE_ALUOP<=2'b0;
      IE_RegDst<=1'b0;
      IE_PC1_ADD_out<=32'b0;
		IE_ALU_in1<=32'b0;
		IE_ALU_in2<=32'b0;
		IE_Signextend_out<=32'b0;
		IE_Instruction<=32'b0;
	end 
	else begin
		IE_MemtoReg<=MemtoReg;
      IE_RegWrite<=RegWrite;
      IE_MemWrite<=MemWrite;
      IE_MemRead<=MemRead;
      IE_Branch<=Branch;
      
      IE_ALUOP<=ALUOP;
      IE_RegDst<=RegDst;
      IE_PC1_ADD_out<=II_PC1_ADD_out;
      IE_ALU_in1<=Readdata1;
		IE_ALU_in2<=Readdata2;
		IE_Signextend_out<=Signextend_out;
		IE_Instruction<=II_Instruction;
	end
end



/*********************************************************EXE Sequential電路***************************************************************/

always @(posedge clk or posedge rst)
begin
	if(rst) begin
		EM_MemtoReg	<= 1'b0;
		EM_RegWrite	<= 1'b0;
		EM_MemWrite	<= 1'b0;
		EM_MemRead 	<= 1'b0;
		EM_Branch	<= 1'b0;	
		
		EM_Result<=32'b0;
		EM_ZERO<=1'b0;
		EM_Readdata2<=32'b0;		
		EM_PC2_ADD_out<=32'b0;
		EM_Rd<=5'b0;
		EM_Instruction <= 32'b0;
	end 
	else begin
	   EM_MemtoReg	<= IE_MemtoReg;
		EM_RegWrite	<= IE_RegWrite;	
		EM_MemWrite	<= IE_MemWrite;
		EM_MemRead 	<= IE_MemRead;
		EM_Branch	<= IE_Branch;
		
		EM_Result<=Result;
		EM_ZERO<=ZERO;  
		EM_Readdata2<=IE_ALU_in2;
		EM_PC2_ADD_out<=PC2_ADD_out;
		EM_Rd<=Rd;
		EM_Instruction <= IE_Instruction;	
	end
end

		
/****************************************************ID Combinational電路****************************************************************/

always @(*)
		case(II_Instruction[31:26])
		6'd0: // R-type 
		begin 
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b1;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b10;
                    RegDst=1'b1;
					     end
				endcase
		      			
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]]; 			
				Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
		end
		
		6'd35:  
		begin// lw
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
		              MemtoReg=1'b1;
                    RegWrite=1'b1;
                    MemWrite=1'b0;
                    MemRead=1'b1;
                    Branch=1'b0;
                   
                    ALUOP=2'b0;
                    RegDst=1'b0;
				        end
				endcase
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]]; 						
			   Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
		 	end
		
		6'd43:  
		begin// sw
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
			           MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b1;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
						  end
				endcase
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]]; 						
			   Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
   		end
		
		6'd8:  
		begin// addi
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
			           MemtoReg=1'b0;
                    RegWrite=1'b1;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
				        end
				endcase
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]]; 						
			   Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
		   end
		
		
		6'd4:   
		begin// beq
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
			           MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b1;
                    
                    ALUOP=2'b01;
                    RegDst=1'b0;
						  end
				endcase
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]];								
				Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
			end
		
		6'd5:   
		begin// bne
		      case(Control_mux)
				   1'b0:begin
					     MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b0;
                    
                    ALUOP=2'b0;
                    RegDst=1'b0;
					     end
				   1'b1:begin
			           MemtoReg=1'b0;
                    RegWrite=1'b0;
                    MemWrite=1'b0;
                    MemRead=1'b0;
                    Branch=1'b1;
                    
                    ALUOP=2'b01;
                    RegDst=1'b0;
						  end
				endcase
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]];								
				Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
			end
			
			default: 
			begin
			   MemtoReg=1'b0;
            RegWrite=1'b0;
            MemWrite=1'b0;
            MemRead=1'b0;
            Branch=1'b0;
           
            ALUOP=2'b00;
            RegDst=1'b0;
				
				Readdata1 =REG[II_Instruction[25:21]]; 
				Readdata2 =REG[II_Instruction[20:16]]; 		
						
			   Signextend_out = { { 16{II_Instruction[15]} } , II_Instruction[15:0] };//sign_extend(IR[15:0]);
				$display("ERROR II_instruction!!");
			end
		endcase


/***************暫存器初始值****************/
always@(*)
begin
   if(rst)begin
	   REG[0]=32'd0;//定義ZERO
	   REG[16]=32'd4;//s0=p
	   REG[17]=32'd64;//s1=q
	   REG[18]=32'd11;//s2=sum
	   REG[8]=32'd29;//t0=i
	   REG[19]=32'd51;//s3
	   REG[9]=32'd88;//t1
		
		REG[11]=32'd0;//t3 讀值用
		REG[20]=32'd64;//s4=64 讀值用
		
		REG[1]=32'd0;
		REG[2]=32'd0;
		REG[3]=32'd0;
		REG[4]=32'd0;
		REG[5]=32'd0;
		REG[6]=32'd0;
		REG[7]=32'd0;
		REG[10]=32'd0;
		REG[12]=32'd0;
		REG[13]=32'd0;
		REG[14]=32'd0;
		REG[15]=32'd0;
	end
	else begin
      if(MW_RegWrite)   
	      REG[MW_RD]=Reg_WriteData;
   end
end

/***************控制Reg寫入時間*****************/
always@(negedge clk)
begin
   Reg_WriteData <= (MW_MemtoReg)? MW_MemData : MW_Result;
end

/************Data Hazard偵測、控制**************/
always@(*)
begin
   if( IE_MemRead && ( (IE_Instruction[20:16]==II_Instruction[25:21]) || (IE_Instruction[20:16]==II_Instruction[20:16]) ))begin
      PC_Write=1'b0;
      II_Write=1'b0;
      Control_mux=1'b0;
   end
   else begin
	   PC_Write=1'b1;
      II_Write=1'b1;
      Control_mux=1'b1;
	end
end



/****************************************************EXE Combinational電路****************************************************************/
always@(*)
begin
   casez({IE_Instruction[31:26],IE_Instruction[5:0],IE_ALUOP})
	   14'b000000_100000_10:ALU_operation_control = 4'b0010;//ADD
		14'b000000_100010_10:ALU_operation_control = 4'b0110;//SUB
		14'b000000_100100_10:ALU_operation_control = 4'b0000;//AND
		14'b000000_000000_10:ALU_operation_control = 4'b0011;//SLL
		14'b000000_100101_10:ALU_operation_control = 4'b0001;//OR
		14'b000000_101010_10:ALU_operation_control = 4'b0111;//SLT
		14'b100011_??????_00:ALU_operation_control = 4'b0010;//LW
		14'b101011_??????_00:ALU_operation_control = 4'b0010;//SW
		14'b001000_??????_00:ALU_operation_control = 4'b0010;//addi
		14'b000100_??????_??:ALU_operation_control = 4'b0110;//BEQ
		14'b000101_??????_??:ALU_operation_control = 4'b0100;//BNE
	   default:ALU_operation_control = 4'b1111;
	endcase
end


always@(*)
begin
  case(ALU_operation_control)
  AND:begin//0000
       Result = ALU_in1 & ALU_in2;
       ZERO = 1'b0;		 
      end  
  OR:begin//0001
       Result = ALU_in1 | ALU_in2;
       ZERO = 1'b0;		 
      end	
  ADD:begin//0010
       Result = ALU_in1 + ALU_in2;
       ZERO = 1'b0;		 
      end 
  SLL:begin//0011
       Result = ALU_in2 << IE_Instruction[10:6];
       ZERO = 1'b0;		 
      end		
  SUB:begin//0110
       Result = ALU_in1 - ALU_in2;
       ZERO = (|Result)? 1'b0:1'b1;		 
      end  
  SLT:begin//0111
       Result = 32'b0;
       ZERO = (ALU_in1<ALU_in2)? 1'b1 : 1'b0;
      end
  NOR:begin//1100
       Result =  ~(ALU_in1 | ALU_in2);
		 ZERO = 1'b0;
		end
  XOR:begin//0100	
       Result = ALU_in1^ALU_in2;
       ZERO =(|Result)? 1'b1:1'b0;
      end		 
  default:begin//other
           Result = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
           ZERO = 1'b0;    
          end
	endcase	
end

/***************ALUin1輸入來源*******************/
always@(*)
begin
   case(ForwardA)
	   2'b10:ALU_in1=EM_Result;
		2'b01:ALU_in1=Reg_WriteData;
		default:ALU_in1=IE_ALU_in1;
   endcase
end
/***************ALUin2輸入來源******************/
always@(*)
begin
  case(ForwardB)
    2'b11:ALU_in2=IE_Signextend_out ; 
    2'b10:ALU_in2=EM_Result;
	 2'b01:ALU_in2=Reg_WriteData;
    2'b00:ALU_in2=IE_ALU_in2 ;
  endcase
end

/******************Rd選擇**********************/
always@(*)
begin
   case(IE_RegDst)
	   1'b0:Rd=IE_Instruction[20:16];
		1'b1:Rd=IE_Instruction[15:11];
	endcase
end
	  
/*************Branch跳躍位置計算****************/	  
always@(*)
begin
   PC2_ADD_in2 = (IE_Signextend_out << 2);
	PC2_ADD_out = IE_PC1_ADD_out + PC2_ADD_in2;
end



/***************Forwarding Unit控制區******************/
always@(*)
begin
   if(  EM_RegWrite && (EM_Instruction[15:11]!=5'b0) &&  (EM_Instruction[15:11]==IE_Instruction[25:21])) begin
      ForwardA=2'b10;//EX hazard
   end
	else if( MW_RegWrite && (MW_Instruction[15:11]!=5'b0) && ~(EM_RegWrite && (EM_Instruction[15:11]!=5'b0) && (EM_Instruction[15:11]==IE_Instruction[25:21]))
	   && (MW_Instruction[15:11]==IE_Instruction[25:21]))begin
	   ForwardA=2'b01;//MEM hazard
	end
	else begin
	   ForwardA=2'b00;
	end
	
	
	if(  EM_RegWrite && ((EM_Instruction[15:11]!=5'b0)||(IE_Instruction[31:26]==6'd5)) &&  ((EM_Instruction[15:11]==IE_Instruction[20:16])||(IE_Instruction[31:26]==6'd5))) begin
      ForwardB=2'b10;//EX hazard
   end
	else if( MW_RegWrite && (MW_Instruction[15:11]!=5'b0) && ~(EM_RegWrite && (EM_Instruction[15:11]!=5'b0) && (EM_Instruction[15:11]==IE_Instruction[20:16]))
	   && (MW_Instruction[15:11]==IE_Instruction[20:16]))begin
	   ForwardB=2'b01;//MEM hazard
	end
   else if(  (IE_Instruction[31:26]==6'd35) ||  (IE_Instruction[31:26]==6'd43)  ||  (IE_Instruction[31:26]==6'd8))begin
      ForwardB=2'b11;
	end
	else begin
	   ForwardB=2'b00;
   end		
	
end



endmodule
