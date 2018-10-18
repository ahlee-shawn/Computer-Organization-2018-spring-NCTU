`timescale 1ns / 1ps
//李昂軒 0516327
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Forwarding(
	EX_Rs,
	EX_Rt,
	MEM_Rd,
	MEM_RegWrite,
	WB_Rd,
	WB_RegWrite,
	Forward_A,
	Forward_B
    );

input 	[4:0]	EX_Rs;
input 	[4:0]	EX_Rt;
input 	[4:0]	MEM_Rd;
input 			MEM_RegWrite;
input 	[4:0]	WB_Rd;
input 			WB_RegWrite;
output	[1:0]	Forward_A;
output	[1:0]	Forward_B;

reg 	[1:0]	result_A = 2'b00;
reg 	[1:0]	result_B = 2'b00;

always@(*)begin
	if((MEM_RegWrite) && (MEM_Rd != 0) && (MEM_Rd == EX_Rs)) result_A = 2'b01;
	else if((WB_RegWrite) && (WB_Rd != 0) && (!((MEM_RegWrite) && (MEM_Rd != 0) && (MEM_Rd == EX_Rs))) && (WB_Rd == EX_Rs)) result_A = 2'b10;
	else result_A = 2'b00;
	if((MEM_RegWrite) && (MEM_Rd != 0) && (MEM_Rd == EX_Rt)) result_B = 2'b01;
	else if((WB_RegWrite) && (WB_Rd != 0) && (!((MEM_RegWrite) && (MEM_Rd != 0) && (MEM_Rd == EX_Rt))) && (WB_Rd == EX_Rt)) result_B = 2'b10;
	else result_B = 2'b00;
end

assign Forward_A = result_A;
assign Forward_B = result_B;

endmodule	