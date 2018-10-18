`timescale 1ns / 1ps
//§õ©ù°a 0516327
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
module Pipe_Reg(
    clk_i,
    rst_i,
	write,
	flush,
    data_i,
    data_o,
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   flush;
input	write;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i) begin
    if(~rst_i || flush) data_o <= 0;
    else if(write) data_o <= data_i;
	else data_o <= data_o;
end

endmodule	