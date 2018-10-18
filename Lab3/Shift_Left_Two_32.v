//§õ©ù°a 0516327
//Subject:      CO project 2 - Shift_Left_Two_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Shift_Left_Two_32(
    data_i,
    data_o
    );
parameter size = 0;	
//I/O ports                    
input [size-1:0] data_i;
output [size-1:0] data_o;

//shift left 2
assign data_o[size-1:0] = {data_i[size-3:0], 1'b0, 1'b0};

endmodule
