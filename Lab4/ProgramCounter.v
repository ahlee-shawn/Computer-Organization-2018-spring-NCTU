//�����a 0516327
//Subject:     CO project 2 - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
	rst_i,
	pc_in_i,
	pc_out_o
	);

input           clk_i;
input	        rst_i;
input  [32-1:0] pc_in_i;
output [32-1:0] pc_out_o;

reg    [32-1:0] pc_out_o;

always @(posedge clk_i) begin
    if(~rst_i)
	    pc_out_o <= 0;
	else
	    pc_out_o <= pc_in_i;
end

endmodule