`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );
		   
localparam [3:0] AND = 4'b0000, OR = 4'b0001, ADD = 4'b0010, SUB = 4'b0110,
				 NOR = 4'b1100, SLT = 4'b0111;
		   
input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input  [4-1:0]  ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg             zero;
reg             cout;
reg            overflow;
reg             constant_zero = 1'b0;
reg 			cin_first;
wire			set;

wire	[31:0]  out;
reg  	[31:0]  out2;
wire    [31:0]  carry_out;

always@(posedge clk) begin
	if(out == 32'b0) zero <= 1;
	else zero <= 0;
end

always@(posedge clk) begin
    if(rst_n) out2[31:0] <= out[31:0];
end

assign result[31:0] = out2[31:0];

always@(*) begin
	if(ALU_control == ADD) cin_first = 1'b0;
	else if(ALU_control == SUB) cin_first = 1'b1;
	else if(ALU_control == SLT) cin_first = 1'b1;
	else cin_first = cin_first;
end

always@(posedge clk) begin
	if(ALU_control == ADD) begin
		if((src1[31] == src2[31]) && (out[31] != src1[31])) overflow <= 1'b1;
		else overflow <= 1'b0;
		end
	else if(ALU_control == SUB) begin
		if((src1[31] != src2[31]) && (out[31] != src1[31])) overflow <= 1'b1;
		else overflow <= 1'b0;
		end
	else overflow <= 1'b0;
end

always@(posedge clk) begin
	if(ALU_control == ADD) begin
		if(carry_out[31] == 1) cout <= 1;
		else cout <= 0;
		end
	else if(ALU_control == SUB) begin
		if(src1[31] == 1'b0 && src2[31] == 1'b1) cout <= 1;
		else if(src1[31] == 1'b1 && src2[31] == 1'b0) cout <= 0;
		else cout <= carry_out[30];
		end
	else cout <= 0;
end

alu_top alu_top0(
		.src1(src1[0]),
		.src2(src2[0]),
		.less(set),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(cin_first),
		.operation(ALU_control[1:0]),
		.result(out[0]),
		.cout(carry_out[0])
       );
alu_top alu_top1(
		.src1(src1[1]),
		.src2(src2[1]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[0]),
		.operation(ALU_control[1:0]),
		.result(out[1]),
		.cout(carry_out[1])
       );
alu_top alu_top2(
		.src1(src1[2]),
		.src2(src2[2]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[1]),
		.operation(ALU_control[1:0]),
		.result(out[2]),
		.cout(carry_out[2])
       );
alu_top alu_top3(
		.src1(src1[3]),
		.src2(src2[3]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[2]),
		.operation(ALU_control[1:0]),
		.result(out[3]),
		.cout(carry_out[3])
       );
alu_top alu_top4(
		.src1(src1[4]),
		.src2(src2[4]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[3]),
		.operation(ALU_control[1:0]),
		.result(out[4]),
		.cout(carry_out[4])
       );
alu_top alu_top5(
		.src1(src1[5]),
		.src2(src2[5]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[4]),
		.operation(ALU_control[1:0]),
		.result(out[5]),
		.cout(carry_out[5])
       );
alu_top alu_top6(
		.src1(src1[6]),
		.src2(src2[6]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[5]),
		.operation(ALU_control[1:0]),
		.result(out[6]),
		.cout(carry_out[6])
       );
alu_top alu_top7(
		.src1(src1[7]),
		.src2(src2[7]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[6]),
		.operation(ALU_control[1:0]),
		.result(out[7]),
		.cout(carry_out[7])
       );
alu_top alu_top8(
		.src1(src1[8]),
		.src2(src2[8]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[7]),
		.operation(ALU_control[1:0]),
		.result(out[8]),
		.cout(carry_out[8])
       );
alu_top alu_top9(
		.src1(src1[9]),
		.src2(src2[9]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[8]),
		.operation(ALU_control[1:0]),
		.result(out[9]),
		.cout(carry_out[9])
       );
alu_top alu_top10(
		.src1(src1[10]),
		.src2(src2[10]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[9]),
		.operation(ALU_control[1:0]),
		.result(out[10]),
		.cout(carry_out[10])
       );
alu_top alu_top11(
		.src1(src1[11]),
		.src2(src2[11]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[10]),
		.operation(ALU_control[1:0]),
		.result(out[11]),
		.cout(carry_out[11])
       );
alu_top alu_top12(
		.src1(src1[12]),
		.src2(src2[12]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[11]),
		.operation(ALU_control[1:0]),
		.result(out[12]),
		.cout(carry_out[12])
       );
alu_top alu_top13(
		.src1(src1[13]),
		.src2(src2[13]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[12]),
		.operation(ALU_control[1:0]),
		.result(out[13]),
		.cout(carry_out[13])
       );
alu_top alu_top14(
		.src1(src1[14]),
		.src2(src2[14]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[13]),
		.operation(ALU_control[1:0]),
		.result(out[14]),
		.cout(carry_out[14])
       );
alu_top alu_top15(
		.src1(src1[15]),
		.src2(src2[15]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[14]),
		.operation(ALU_control[1:0]),
		.result(out[15]),
		.cout(carry_out[15])
       );
alu_top alu_top16(
		.src1(src1[16]),
		.src2(src2[16]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[15]),
		.operation(ALU_control[1:0]),
		.result(out[16]),
		.cout(carry_out[16])
       );
alu_top alu_top17(
		.src1(src1[17]),
		.src2(src2[17]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[16]),
		.operation(ALU_control[1:0]),
		.result(out[17]),
		.cout(carry_out[17])
       );
alu_top alu_top18(
		.src1(src1[18]),
		.src2(src2[18]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[17]),
		.operation(ALU_control[1:0]),
		.result(out[18]),
		.cout(carry_out[18])
       );
alu_top alu_top19(
		.src1(src1[19]),
		.src2(src2[19]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[18]),
		.operation(ALU_control[1:0]),
		.result(out[19]),
		.cout(carry_out[19])
       );
alu_top alu_top20(
		.src1(src1[20]),
		.src2(src2[20]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[19]),
		.operation(ALU_control[1:0]),
		.result(out[20]),
		.cout(carry_out[20])
       );
alu_top alu_top21(
		.src1(src1[21]),
		.src2(src2[21]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[20]),
		.operation(ALU_control[1:0]),
		.result(out[21]),
		.cout(carry_out[21])
       );
alu_top alu_top22(
		.src1(src1[22]),
		.src2(src2[22]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[21]),
		.operation(ALU_control[1:0]),
		.result(out[22]),
		.cout(carry_out[22])
       );
alu_top alu_top23(
		.src1(src1[23]),
		.src2(src2[23]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[22]),
		.operation(ALU_control[1:0]),
		.result(out[23]),
		.cout(carry_out[23])
       );
alu_top alu_top24(
		.src1(src1[24]),
		.src2(src2[24]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[23]),
		.operation(ALU_control[1:0]),
		.result(out[24]),
		.cout(carry_out[24])
       );
alu_top alu_top25(
		.src1(src1[25]),
		.src2(src2[25]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[24]),
		.operation(ALU_control[1:0]),
		.result(out[25]),
		.cout(carry_out[25])
       );
alu_top alu_top26(
		.src1(src1[26]),
		.src2(src2[26]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[25]),
		.operation(ALU_control[1:0]),
		.result(out[26]),
		.cout(carry_out[26])
       );
alu_top alu_top27(
		.src1(src1[27]),
		.src2(src2[27]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[26]),
		.operation(ALU_control[1:0]),
		.result(out[27]),
		.cout(carry_out[27])
       );
alu_top alu_top28(
		.src1(src1[28]),
		.src2(src2[28]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[27]),
		.operation(ALU_control[1:0]),
		.result(out[28]),
		.cout(carry_out[28])
       );
alu_top alu_top29(
		.src1(src1[29]),
		.src2(src2[29]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[28]),
		.operation(ALU_control[1:0]),
		.result(out[29]),
		.cout(carry_out[29])
       );
alu_top alu_top30(
		.src1(src1[30]),
		.src2(src2[30]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[29]),
		.operation(ALU_control[1:0]),
		.result(out[30]),
		.cout(carry_out[30])
       );
alu_bottom alu_bottom31(
		.src1(src1[31]),
		.src2(src2[31]),
		.less(constant_zero),
		.A_invert(ALU_control[3]),
		.B_invert(ALU_control[2]),
		.cin(carry_out[30]),
		.operation(ALU_control[1:0]),
		.result(out[31]),
		.set(set),
		.cout(carry_out[31])
       );
endmodule


