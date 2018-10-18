//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire	[31:0]	IF_PC_In;
wire	[31:0]	IF_PC_Out;
wire	[31:0]	IF_PC_Add4;
wire	[31:0]	IF_Instruction;

/**** ID stage ****/
wire	[31:0]	ID_PC_Add4;
wire	[31:0]	ID_Instruction;
wire	[31:0]	ID_Instruction_Extended;
wire	[31:0]	ID_ReadData1;
wire	[31:0]	ID_ReadData2;
//control signal
wire         	ID_Branch;
wire			ID_MemToReg;
wire			ID_MemRead;
wire			ID_MemWrite;
wire 	[2:0]	ID_ALUOp;
wire         	ID_ALUSrc;
wire         	ID_RegWrite;
wire	     	ID_RegDest; 

/**** EX stage ****/
wire	[31:0]	EX_ALU_Result;
wire	[31:0]	EX_ReadData1;
wire	[31:0]	EX_ReadData2;
wire	[31:0]	EX_PC_Add4;
wire	[31:0]	EX_Instruction_Extended;
wire	[4:0]	EX_Instruction_25_21;
wire	[4:0]	EX_Instruction_20_16;
wire	[4:0]	EX_Instruction_15_11;
wire	[31:0]	EX_Shift_Left;
wire	[31:0]	EX_ALUSource1;
wire	[31:0]	EX_ALUSource2;
wire	[4:0]	EX_RegWriteRegister;
wire	[31:0]	EX_PC_Branch;


//control signal
wire         	EX_Branch;
wire			EX_MemToReg;
wire			EX_MemRead;
wire			EX_MemWrite;
wire 	[2:0]	EX_ALUOp;
wire         	EX_ALUSrc;
wire         	EX_RegWrite;
wire	     	EX_RegDest; 
wire			EX_Zero;
wire	[3:0]	EX_ALUCtrl;

/**** MEM stage ****/
wire 			MEM_PCSrc;
wire	[31:0]	MEM_ALU_Result;
wire	[31:0]	MEM_PC_Branch;
wire	[31:0]	MEM_ReadData2;
wire	[4:0]	MEM_RegWriteRegister;
wire	[31:0]	MEM_Memory_Out;

//control signal
wire         	MEM_Branch;
wire			MEM_MemToReg;
wire			MEM_MemRead;
wire			MEM_MemWrite;
wire         	MEM_RegWrite;
wire			MEM_Zero;

/**** WB stage ****/
wire	[31:0]	WB_Memory_Out;
wire	[31:0]	WB_ALU_Result;
//control signal
wire			WB_RegWrite;
wire			WB_MemToReg;
wire	[31:0]	WB_RegWriteData;
wire	[4:0]	WB_RegWriteRegister;
wire	[31:0]	WB_ReadData2;

wire			PC_Write;
wire			IF_ID_Write;
wire			IF_Flush;
wire			ID_Flush;
wire			EX_Flush;
wire	[1:0]	ID_BranchType;
wire	[1:0]	EX_BranchType;
wire	[1:0]	MEM_BranchType;
wire	[1:0]	Forward_A;
wire	[1:0]	Forward_B;
wire	[31:0]	MuxB_o;
wire			not_MEM_Zero;
wire	[31:0]	not_MEM_ALU_Result;
wire			MUX4_1_i;
wire			MUX4_1_o;

/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(IF_PC_Add4),
	.data1_i(MEM_PC_Branch),
	.select_i(MEM_PCSrc),
    .data_o(IF_PC_In)
);

ProgramCounter PC(
	.clk_i(clk_i),
	.rst_i(rst_i),
	.pc_write(PC_Write),
	.pc_in_i(IF_PC_In),
	.pc_out_o(IF_PC_Out)
);

Instruction_Memory IM(
	.addr_i(IF_PC_Out),
    .instr_o(IF_Instruction)
);

Adder Add_pc(
	.src1_i(IF_PC_Out),
	.src2_i(32'd4),
	.sum_o(IF_PC_Add4)
);

Pipe_Reg #(.size(32)) IF_ID_PC_Add4(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(IF_ID_Write),
	.flush(IF_Flush),
    .data_i(IF_PC_Add4),
    .data_o(ID_PC_Add4)
);

Pipe_Reg #(.size(32)) IF_ID_Instruction(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(IF_ID_Write),
	.flush(IF_Flush),
    .data_i(IF_Instruction),
    .data_o(ID_Instruction)
);
//Instantiate the components in ID stage
Reg_File RF(
	.clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(ID_Instruction[25:21]),
    .RTaddr_i(ID_Instruction[20:16]),
    .RDaddr_i(WB_RegWriteRegister),
    .RDdata_i(WB_RegWriteData),
    .RegWrite_i(WB_RegWrite),
    .RSdata_o(ID_ReadData1),
    .RTdata_o(ID_ReadData2)
);

Decoder Control(
	.instr_op_i(ID_Instruction[31:26]),
    .Branch(ID_Branch),
	.MemToReg(ID_MemToReg),
	.MemRead(ID_MemRead),
	.MemWrite(ID_MemWrite),
	.ALUOp(ID_ALUOp),
	.ALUSrc(ID_ALUSrc),
	.RegWrite(ID_RegWrite),
	.RegDest(ID_RegDest),
	.BranchType(ID_BranchType)
);

HazardDetection HazardDetection(
	.EX_MemRead(EX_MemRead),
	.EX_Rt(EX_Instruction_20_16),
	.ID_Rs(ID_Instruction[25:21]),
	.ID_Rt(ID_Instruction[20:16]),
	.PCSrc(MEM_PCSrc),
	.PC_Write(PC_Write),
	.IF_ID_Write(IF_ID_Write),
	.IF_Flush(IF_Flush),
	.ID_Flush(ID_Flush),
	.EX_Flush(EX_Flush)
);

Sign_Extend Sign_Extend(
    .data_i(ID_Instruction[15:0]),
    .data_o(ID_Instruction_Extended)
);	

Pipe_Reg #(.size(32)) ID_EX_ReadData1(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_ReadData1),
    .data_o(EX_ReadData1)
);

Pipe_Reg #(.size(32)) ID_EX_ReadData2(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_ReadData2),
    .data_o(EX_ReadData2)
);

Pipe_Reg #(.size(1)) ID_EX_Branch(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_Branch),
    .data_o(EX_Branch)
);

Pipe_Reg #(.size(1)) ID_EX_MemToReg(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_MemToReg),
    .data_o(EX_MemToReg)
);

Pipe_Reg #(.size(1)) ID_EX_MemRead(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_MemRead),
    .data_o(EX_MemRead)
);

Pipe_Reg #(.size(1)) ID_EX_MemWrite(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_MemWrite),
    .data_o(EX_MemWrite)
);

Pipe_Reg #(.size(3)) ID_EX_ALUOp(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_ALUOp),
    .data_o(EX_ALUOp)
);

Pipe_Reg #(.size(1)) ID_EX_ALUSrc(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_ALUSrc),
    .data_o(EX_ALUSrc)
);

Pipe_Reg #(.size(1)) ID_EX_RegWrite(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_RegWrite),
    .data_o(EX_RegWrite)
);

Pipe_Reg #(.size(1)) ID_EX_RegDest(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_RegDest),
    .data_o(EX_RegDest)
);

Pipe_Reg #(.size(2)) ID_EX_BranchType(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(ID_BranchType),
    .data_o(EX_BranchType)
);

Pipe_Reg #(.size(32)) ID_EX_PC_Add4(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_PC_Add4),
    .data_o(EX_PC_Add4)
);

Pipe_Reg #(.size(32)) ID_EX_Instruction_Extended(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_Instruction_Extended),
    .data_o(EX_Instruction_Extended)
);

Pipe_Reg #(.size(5)) ID_EX_Instruction_25_21(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_Instruction[25:21]),
    .data_o(EX_Instruction_25_21)
);

Pipe_Reg #(.size(5)) ID_EX_Instruction_20_16(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_Instruction[20:16]),
    .data_o(EX_Instruction_20_16)
);

Pipe_Reg #(.size(5)) ID_EX_Instruction_15_11(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(ID_Instruction[15:11]),
    .data_o(EX_Instruction_15_11)
);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(EX_Instruction_Extended),
    .data_o(EX_Shift_Left)
);

Forwarding Forwarding_Unit(
	.EX_Rs(EX_Instruction_25_21),
	.EX_Rt(EX_Instruction_20_16),
	.MEM_Rd(MEM_RegWriteRegister),
	.MEM_RegWrite(MEM_RegWrite),
	.WB_Rd(WB_RegWriteRegister),
	.WB_RegWrite(WB_RegWrite),
	.Forward_A(Forward_A),
	.Forward_B(Forward_B)
    );

MUX_3to1 #(.size(32)) MuxA(
	.data0_i(EX_ReadData1),
	.data1_i(MEM_ALU_Result),
	.data2_i(WB_RegWriteData),
	.select_i(Forward_A),
    .data_o(EX_ALUSource1)
);

MUX_3to1 #(.size(32)) MuxB(
	.data0_i(EX_ReadData2),
	.data1_i(MEM_ALU_Result),
	.data2_i(WB_RegWriteData),
	.select_i(Forward_B),
    .data_o(MuxB_o)
);

MUX_2to1 #(.size(32)) Mux_ALU_Source2(
	.data0_i(MuxB_o),
	.data1_i(EX_Instruction_Extended),
	.select_i(EX_ALUSrc),
    .data_o(EX_ALUSource2)
);
	
ALU ALU(
    .src1_i(EX_ALUSource1),
	.src2_i(EX_ALUSource2),
	.ctrl_i(EX_ALUCtrl),
	.result_o(EX_ALU_Result),
	.zero_o(EX_Zero)
);
		
ALU_Ctrl ALU_Control(
	.funct_i(EX_Instruction_Extended[5:0]),
	.ALUOp_i(EX_ALUOp),
	.ALUCtrl_o(EX_ALUCtrl)
);

MUX_2to1 #(.size(5)) Mux2(
	.data0_i(EX_Instruction_20_16),
	.data1_i(EX_Instruction_15_11),
	.select_i(EX_RegDest),
    .data_o(EX_RegWriteRegister)
);

Adder Add_pc_branch(
	.src1_i(EX_PC_Add4),
	.src2_i(EX_Shift_Left),
	.sum_o(EX_PC_Branch)
);

Pipe_Reg #(.size(1)) EX_MEM_RegWrite(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_RegWrite),
    .data_o(MEM_RegWrite)
);

Pipe_Reg #(.size(1)) EX_MEM_Branch(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_Branch),
    .data_o(MEM_Branch)
);

Pipe_Reg #(.size(1)) EX_MEM_MemToReg(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_MemToReg),
    .data_o(MEM_MemToReg)
);

Pipe_Reg #(.size(1)) EX_MEM_MemRead(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_MemRead),
    .data_o(MEM_MemRead)
);

Pipe_Reg #(.size(1)) EX_MEM_MemWrite(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_MemWrite),
    .data_o(MEM_MemWrite)
);

Pipe_Reg #(.size(1)) EX_MEM_Zero(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(EX_Flush),
    .data_i(EX_Zero),
    .data_o(MEM_Zero)
);

Pipe_Reg #(.size(32)) EX_MEM_PC_Branch(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(EX_PC_Branch),
    .data_o(MEM_PC_Branch)
);

Pipe_Reg #(.size(32)) EX_MEM_ALU_Result(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(EX_ALU_Result),
    .data_o(MEM_ALU_Result)
);

Pipe_Reg #(.size(32)) EX_MEM_ReadData2(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MuxB_o),
    .data_o(MEM_ReadData2)
);

Pipe_Reg #(.size(5)) EX_MEM_RegWriteRegister(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(EX_RegWriteRegister),
    .data_o(MEM_RegWriteRegister)
);

Pipe_Reg #(.size(2)) EX_MEM_BranchType(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(ID_Flush),
    .data_i(EX_BranchType),
    .data_o(MEM_BranchType)
);


//Instantiate the components in MEM stage
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(MEM_ALU_Result),
    .data_i(MEM_ReadData2),
    .MemRead_i(MEM_MemRead),
    .MemWrite_i(MEM_MemWrite),
    .data_o(MEM_Memory_Out)
);

not	G1	(not_MEM_Zero, MEM_Zero);
//not	G2	(not_MEM_ALU_Result, MEM_ALU_Result);
nor	G3	(MUX4_1_i, MEM_Zero, MEM_ALU_Result[0]);

MUX_4to1 #(.size(1)) Mux4_1(
	.data0_i(MEM_Zero),
	.data1_i(MUX4_1_i),
	.data2_i(~MEM_ALU_Result),
	.data3_i(~MEM_Zero),
	.select_i(MEM_BranchType),
    .data_o(MUX4_1_o)
);

and G4 (MEM_PCSrc, MUX4_1_o, MEM_Branch);

Pipe_Reg #(.size(32)) MEM_WB_Memory_Out(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MEM_Memory_Out),
    .data_o(WB_Memory_Out)
);

Pipe_Reg #(.size(1)) MEM_WB_RegWrite(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MEM_RegWrite),
    .data_o(WB_RegWrite)
);

Pipe_Reg #(.size(1)) MEM_WB_MemToReg(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MEM_MemToReg),
    .data_o(WB_MemToReg)
);

Pipe_Reg #(.size(32)) MEM_WB_ReadData2(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MEM_ALU_Result),
    .data_o(WB_ReadData2)
);

Pipe_Reg #(.size(5)) MEM_WB_RegWriteRegister(
	.clk_i(clk_i),
    .rst_i(rst_i),
	.write(1'b1),
	.flush(1'b0),
    .data_i(MEM_RegWriteRegister),
    .data_o(WB_RegWriteRegister)
);

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
	.data0_i(WB_Memory_Out),
	.data1_i(WB_ReadData2),
	.select_i(WB_MemToReg),
    .data_o(WB_RegWriteData)
);

/****************************************
signal assignment
****************************************/

endmodule