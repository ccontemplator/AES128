`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/06 04:23:06
// Design Name: 
// Module Name: Mix_columns
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


module Mix_columns(
    input [127:0] Mix_columns_input_text,
    output [127:0] Mix_columns_output_text
);

wire [7:0] s00,b00;
wire [7:0] s01,b01;
wire [7:0] s02,b02;
wire [7:0] s03,b03;
///
wire [7:0] s10,b10;
wire [7:0] s11,b11;
wire [7:0] s12,b12;
wire [7:0] s13,b13;
///
wire [7:0] s20,b20;
wire [7:0] s21,b21;
wire [7:0] s22,b22;
wire [7:0] s23,b23;
///
wire [7:0] s30,b30;
wire [7:0] s31,b31;
wire [7:0] s32,b32;
wire [7:0] s33,b33;

assign {s00,s01,s02,s03,s10,s11,s12,s13,s20,s21,s22,s23,s30,s31,s32,s33} = Mix_columns_input_text;

//assignment of first row of output
assign b00 = (2*s00) ^ (3*s10) ^ s20 ^ s30;
assign b01 = (2*s01) ^ (3*s11) ^ s21 ^ s31;
assign b02 = (2*s02) ^ (3*s12) ^ s22 ^ s32;
assign b03 = (2*s03) ^ (3*s13) ^ s23 ^ s33;
//assignment of second row of output
assign b10 = s00 ^ (2*s10) ^ (3*s20) ^ s30;
assign b11 = s01 ^ (2*s11) ^ (3*s21) ^ s31;
assign b12 = s02 ^ (2*s12) ^ (3*s22) ^ s32;
assign b13 = s03 ^ (2*s13) ^ (3*s23) ^ s33;
//assignment of third row of output
assign b20 = s00 ^ s10 ^ (2*s20) ^ (3*s30);
assign b21 = s01 ^ s11 ^ (2*s21) ^ (3*s31);
assign b22 = s02 ^ s12 ^ (2*s22) ^ (3*s32);
assign b23 = s03 ^ s13 ^ (2*s23) ^ (3*s33);
//assignment of fourth row of output
assign b30 = (3*s00) ^ s10 ^ s20 ^ (2*s30);
assign b31 = (3*s01) ^ s11 ^ s21 ^ (2*s31);
assign b32 = (3*s02) ^ s12 ^ s22 ^ (2*s32);
assign b33 = (3*s03) ^ s13 ^ s23 ^ (2*s33);

assign Mix_columns_output_text = {b00,b01,b02,b03,b10,b11,b12,b13,b20,b21,b22,b23,b30,b31,b32,b33}; 

endmodule
