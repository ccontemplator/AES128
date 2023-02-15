`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/06 04:22:22
// Design Name: 
// Module Name: Shift_rows
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


module Shift_rows(
    input [127:0] Shift_rows_input_text,
    output [127:0] Shift_rows_output_text
);

wire [31:0] a0;
wire [31:0] a1;
wire [31:0] a2;
wire [31:0] a3;
assign {a0,a1,a2,a3} = Shift_rows_input_text;

wire [31:0] b1;
wire [31:0] b2;
wire [31:0] b3;
assign b1 = {a1[23:0], a1[31:24]}; //circularly shift left 1 byte
assign b2 = {a2[15:8] , a2[7:0] , a2[31:24] , a2[23:16]}; //circularly shift left 2 bytes
assign b3 = {a3[7:0] , a3[31:24] , a3[23:16] , a3[15:8]}; //circularly shift left 3 bytes

assign Shift_rows_output_text = {b3,b2,b1,a0};

endmodule
