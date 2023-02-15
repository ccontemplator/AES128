`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/05 01:59:57
// Design Name: 
// Module Name: Add_round_key
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


module Add_round_key(
    input [127:0]  round_input_text,
    input [127:0]  rounded_key,
    output [127:0]  round_output_text  
);
assign round_output_text = round_input_text ^ rounded_key;

endmodule
