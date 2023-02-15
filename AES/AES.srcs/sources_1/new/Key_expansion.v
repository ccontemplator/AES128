`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/02/04 18:46:00
// Design Name: 
// Module Name: Key_expansion
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

// 11 rounds
module Key_expansion(
    input [3:0] round, // indicate which round it is, out of 11 round.
    input [127:0] input_key, //16 bytes
    output reg [127:0] rounded_key //16 bytes
);

wire [127:0] cir_shift_input_key;
wire [31:0] w0;
wire [31:0] w1;
wire [31:0] w2;
wire [31:0] w3;
assign cir_shift_input_key = {input_key[31:8],input_key[7:0] ,input_key[63:40],input_key[39:32] ,input_key[95:72],input_key[71:64] , input_key[127:104],input_key[103:96]};
assign {w3,w2,w1,w0} = cir_shift_input_key;

wire [31:0] s0;
wire [31:0] s1;
wire [31:0] s2;
wire [31:0] s3;
assign s0 = w1 * 2 + 'd3;
assign s1 = w3 * 5 - 'd1;
assign s2 = w0 * 2 - 'd3;
assign s3 = w2 * 3 + 'd1;

//rounded_key
always@ (*) begin
    if(round == 'd0) begin
        rounded_key = input_key;
    end
    else begin
        rounded_key = {s3,s2,s1,s0} ^ {round, 124'b0};
    end
end

endmodule
