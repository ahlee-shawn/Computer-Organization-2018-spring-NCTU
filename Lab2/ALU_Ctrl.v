//0516327 李昂軒
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
//reg        [4-1:0] ALUCtrl_o;

//Parameter
reg        [4-1:0] result;
       
//Select exact operation
always@(*)begin
	if(ALUOp_i == 3'b010)begin
		if(funct_i == 6'h20) result <= 4'b0010;
		else if(funct_i == 6'h22) result <= 4'b0110;
		else if(funct_i == 6'h24) result <= 4'b0000;
		else if(funct_i == 6'h25) result <= 4'b0001;
		else if(funct_i == 6'h2a) result <= 4'b0111;
	end else if(ALUOp_i == 3'b001)begin
		result <= 4'b0110;
	end else if(ALUOp_i == 3'b101)begin
		result <= 4'b0010;
	end else if(ALUOp_i == 3'b110)begin
		result <= 4'b0111;
	end
end

assign ALUCtrl_o = result;

endmodule