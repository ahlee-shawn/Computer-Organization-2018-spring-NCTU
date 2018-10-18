`timescale 1ns / 1ps
//李昂軒 0516327
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 16:44:18
// Design Name: 
// Module Name: PC_instr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PC_instr(
	instr,
	pc,
	PC_instr_o
    );
input 	[27:0]	instr;
input	[31:0]	pc;
output	[31:0]	PC_instr_o;
	
assign PC_instr_o = {pc[31:28], instr[27:0]};
	
endmodule
