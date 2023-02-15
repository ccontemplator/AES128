`timescale 1ns / 1ps


module AES_sim();

    reg clk;
    reg en_req;
    reg dec_req;
    wire done; //output
    reg [127:0] in_text;
    wire [127:0] out_text; //output
    
    //clk
    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = ~clk;
        end
    end
    
    //en_req
    initial begin
        en_req = 1'b0;
        #100 en_req = 1'b1;
    end
    always@ (posedge clk) begin
        if(done == 1'b1 && en_req == 1'b1) begin
            en_req <= 1'b0;
        end
        else begin
            en_req <= en_req;
        end
    end
    
    //dec_req
    initial begin
        dec_req <= 1'b0;
    end 
    
    //in_text
    initial begin
        in_text = 128'h11111111_11111111_11111111_11111111;
    end
    
    
AES AES_ins(
    .clk(clk),
    .enc_req(en_req),
    .dec_req(dec_req),
    .in_text(in_text),
    .out_text(out_text),
    .done(done)
);
    
endmodule
