//§õ©ù°a 0516327
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl;

//Parameter

//Select exact operation
always@(*)begin
	if(ALUOp_i == 3'd0)begin
		if(funct_i == 6'd32)ALUCtrl = 4'b0010;
		else if(funct_i == 6'd34)ALUCtrl = 4'b0110;
		else if(funct_i == 6'd36)ALUCtrl = 4'b0000;
		else if(funct_i == 6'd37)ALUCtrl = 4'b0001;
		else if(funct_i == 6'd42)ALUCtrl = 4'b0111;
		else ALUCtrl = 4'b0000;
		end
	else if(ALUOp_i == 3'd1)begin
		ALUCtrl = 4'b0010;
		end
	else if(ALUOp_i == 3'd2)begin
		ALUCtrl = 4'b0110;
		end
	else if(ALUOp_i == 3'd3)begin
		ALUCtrl = 4'b0010;
		end
	else if(ALUOp_i == 3'd4)begin
		ALUCtrl = 4'b0111;
		end
	else if(ALUOp_i == 3'd5)begin
		ALUCtrl = 4'b0000;
		end
end

assign ALUCtrl_o = ALUCtrl;

endmodule