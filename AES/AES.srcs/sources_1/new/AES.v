`timescale 1ns / 1ps


module AES(
    input clk,
    input enc_req,
    input dec_req,
    input [127:0] in_text,
    output [127:0] out_text,
    output done
);

wire [127:0] input_key;
assign input_key = 128'h11111111_11111111_11111111_11111111;

reg EN;
AES_ENC AES_ENC_ins(.clk(clk), .EN(EN), .plain_text(in_text), .input_key(input_key), .cipher_text(out_text), .ENC_done(done));

//EN
always@ (posedge clk) begin 
    if((enc_req == 1'b0 && dec_req == 1'b0) || done == 1'b1) begin
        EN <= 1'b0;
    end
    else if((enc_req == 1'b1 && dec_req == 1'b0 && done == 1'b0) || (enc_req == 1'b0 && dec_req == 1'b1 && done == 1'b0)) begin
         EN <= 1'b1;
    end
    else begin
        EN <= EN;
    end
end



endmodule
