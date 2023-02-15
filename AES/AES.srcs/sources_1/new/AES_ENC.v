`timescale 1ns / 1ps

module AES_ENC(
    input clk,
    input EN, //ENABLE
    input [127:0] plain_text,
    input [127:0] input_key,
    output reg [127:0] cipher_text,
    output reg ENC_done
);

    parameter IDLE = 'd0;
    parameter KEY_EXPANSION = 'd1;
    parameter S_BOX = 'd2;
    parameter SHIFT_ROWS = 'd3;
    parameter MIX_COLUMNS = 'd4;
    parameter ADD_ROUND_KEY = 'd5;
    
    reg [2:0] state ; //totally 5 states
    reg [3:0] round = 'd0; //totally 11 rounds (0~10)
    
    //KEY_EXPANSION
    wire [127:0] rounded_key;
    reg [127:0] round_input_key;
    Key_expansion Key_expansion_ins(.round(round), .input_key(round_input_key), .rounded_key(rounded_key));

    //round I/O
    reg [127:0] ark_input_text;
    wire [127:0] ark_output_text;
    reg [127:0] S_box_input_text;
    wire [127:0] S_box_output_text;
    reg [127:0] Shift_rows_input_text;
    wire [127:0] Shift_rows_output_text;
    reg [127:0] Mix_columns_input_text;
    wire [127:0] Mix_columns_output_text;

    Add_round_key Ark_ins(.ark_input_text(ark_input_text), .rounded_key(rounded_key), .ark_output_text(ark_output_text));    //ARK(the bitwise XOR) should be done in one cycle
    S_box S_BOX_1(.S_box_input_text(S_box_input_text[7:0]), .S_box_output_text(S_box_output_text[7:0]));
    S_box S_BOX_2(.S_box_input_text(S_box_input_text[15:8]), .S_box_output_text(S_box_output_text[15:8]));
    S_box S_BOX_3(.S_box_input_text(S_box_input_text[23:16]), .S_box_output_text(S_box_output_text[23:16]));
    S_box S_BOX_4(.S_box_input_text(S_box_input_text[31:24]), .S_box_output_text(S_box_output_text[31:24]));  
    S_box S_BOX_5(.S_box_input_text(S_box_input_text[39:32]), .S_box_output_text(S_box_output_text[39:32]));
    S_box S_BOX_6(.S_box_input_text(S_box_input_text[47:40]), .S_box_output_text(S_box_output_text[47:40]));
    S_box S_BOX_7(.S_box_input_text(S_box_input_text[55:48]), .S_box_output_text(S_box_output_text[55:48]));
    S_box S_BOX_8(.S_box_input_text(S_box_input_text[63:56]), .S_box_output_text(S_box_output_text[63:56]));  
    S_box S_BOX_9(.S_box_input_text(S_box_input_text[71:64]), .S_box_output_text(S_box_output_text[71:64]));  
    S_box S_BOX_10(.S_box_input_text(S_box_input_text[79:72]), .S_box_output_text(S_box_output_text[79:72]));  
    S_box S_BOX_11(.S_box_input_text(S_box_input_text[87:80]), .S_box_output_text(S_box_output_text[87:80]));  
    S_box S_BOX_12(.S_box_input_text(S_box_input_text[95:88]), .S_box_output_text(S_box_output_text[95:88]));  
    S_box S_BOX_13(.S_box_input_text(S_box_input_text[103:96]), .S_box_output_text(S_box_output_text[103:96]));  
    S_box S_BOX_14(.S_box_input_text(S_box_input_text[111:104]), .S_box_output_text(S_box_output_text[111:104]));  
    S_box S_BOX_15(.S_box_input_text(S_box_input_text[119:112]), .S_box_output_text(S_box_output_text[119:112]));  
    S_box S_BOX_16(.S_box_input_text(S_box_input_text[127:120]), .S_box_output_text(S_box_output_text[127:120]));
    Shift_rows Shift_rows_ins(.Shift_rows_input_text(Shift_rows_input_text), .Shift_rows_output_text(Shift_rows_output_text));    
    Mix_columns Mix_columns_ins(.Mix_columns_input_text(Mix_columns_input_text), .Mix_columns_output_text(Mix_columns_output_text));
    
reg [3:0] counter;

//state
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        state <= IDLE;
    end
    else begin
        case(state) // every task should be done in one clk cycle
            IDLE: begin
                if(EN == 1'b1) begin //round=0
                    state <= KEY_EXPANSION;
                end
                else begin
                    state <= state;
                end
            end
            
            KEY_EXPANSION: begin
                if(counter == 'd10) begin
                    state <= ADD_ROUND_KEY;
                end
                else begin
                    state <= state;
                end
            end
            
            ADD_ROUND_KEY: begin
                if(counter == 'd10) begin
                    if(round == 'd10) begin
                        state <= IDLE;
                    end
                    else begin
                        state <= S_BOX;
                    end
                end
                else begin
                    state <= state;
                end            
            end
            
            S_BOX: begin
                if(counter == 'd10) begin        
                    state <= SHIFT_ROWS;
                end
                else begin
                    state <= state;
                end
            end
            
            SHIFT_ROWS: begin
                if(counter == 'd10) begin
                    if(round == 'd10) begin
                        state <= ADD_ROUND_KEY;
                    end
                    else begin
                        state <= MIX_COLUMNS;
                    end
                end
                else begin
                    state <= state;
                end
            end     
            
            MIX_COLUMNS: begin
                if(counter == 'd10) begin
                    state <= ADD_ROUND_KEY;
                end
                else begin
                    state <= state;
                end
            end     
              
            default: begin
                state <= state;
            end
        endcase
    end
    
end

//counter
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        counter <= 'd0;
    end
    else if((state == KEY_EXPANSION && counter == 'd10) || (state == ADD_ROUND_KEY && counter == 'd10) || (state == S_BOX && counter == 'd10) || (state == SHIFT_ROWS && counter == 'd10) || (state == MIX_COLUMNS && counter == 'd10)) begin
        counter <= 'd0;
    end
    else begin
        counter <= counter + 'd1;
    end
end


//round
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        round <= 'd0;
    end
    else if(state == ADD_ROUND_KEY && counter == 'd10) begin
        if(round == 'd10) begin
            round <= 'd0;
        end
        else begin
            round <= round + 'd1;
        end
    end
    else begin
        round <= round;
    end
end



// S_box_input_text
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        S_box_input_text <= 'd0;
    end
    else if(state == ADD_ROUND_KEY && counter == 'd10) begin //after adding the rounded key
        S_box_input_text <= ark_output_text;
    end
    else begin
        S_box_input_text <= S_box_input_text;
    end
end


// Shift_rows_input_text
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        Shift_rows_input_text <= 'd0;
    end
    else if(state == S_BOX && counter == 'd10) begin //after adding the rounded key
        Shift_rows_input_text <= S_box_output_text;
    end
    else begin
        Shift_rows_input_text <= Shift_rows_input_text;
    end
end

// Mix_columns_input_text
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        Mix_columns_input_text <= 'd0;
    end
    else if(state == SHIFT_ROWS && counter == 'd10) begin 
        if(round == 'd10) begin
            Mix_columns_input_text <= Mix_columns_input_text; //no change
        end
        else begin
            Mix_columns_input_text <= Shift_rows_output_text;
        end
    end
    else begin
        Mix_columns_input_text <= Mix_columns_input_text;
    end
end


//add_round_key_input_text
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        ark_input_text <= 'd0;
    end
    else if(round == 'd0 && EN ==1'b1) begin
        ark_input_text <= plain_text;
    end
    else if(state == MIX_COLUMNS && counter == 'd10) begin
        ark_input_text <= Mix_columns_output_text; 
    end
    else if(round == 'd10 && state == SHIFT_ROWS && counter == 'd10) begin
        ark_input_text <= Shift_rows_output_text;
    end
    else begin
       ark_input_text <= ark_input_text;
    end
end

//round_input_key
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        round_input_key <= 'd0;
    end
    else if(state == IDLE) begin
        round_input_key <= input_key;
    end
    else if(state == ADD_ROUND_KEY && counter == 'd10) begin
        round_input_key <= rounded_key;
    end
    else begin
        round_input_key <= round_input_key;
    end
end

//cipher_text
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        cipher_text <= 'd0;
    end
    else if(state == ADD_ROUND_KEY && counter == 'd10 && round == 'd10) begin
        cipher_text <= ark_output_text;
    end
    else begin
        cipher_text <= cipher_text;
    end
end

//ENC_done
always@ (posedge clk) begin
    if(EN == 1'b0) begin
        ENC_done <= 'd0;
    end
    else if(state == ADD_ROUND_KEY && counter == 'd10 && round == 'd10) begin
        ENC_done <= 1'b1;
    end
    else begin
        ENC_done <= 1'b0;
    end
end

endmodule
