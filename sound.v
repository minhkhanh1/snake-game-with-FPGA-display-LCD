module sound(
    input clk,
    output beep
);

    reg beep_r;
    reg [7:0] state;
    reg [15:0] count, count_end;
    reg [23:0] count1;

    parameter   C4 = 16'd95602,
                D4 = 16'd85131,
                E4 = 16'd75781,
                F4 = 16'd71633,
                G4 = 16'd63775,
                A4 = 16'd56818,
                A4s = 16'd53629,  
                C5 = 16'd47778;

    parameter   TIME = 10000000;  

    assign beep = beep_r;

    always @(posedge clk) begin
        count <= count + 1'b1;
        if (count == count_end) begin
            count <= 16'h0;
            beep_r <= !beep_r;
        end
    end

    always @(posedge clk) begin
        if (count1 < TIME) begin
            count1 = count1 + 1'b1;
        end else begin
            count1 = 24'd0;
            if (state == 8'd24)
                state = 8'd0;
            else
                state = state + 1'b1;
            
            case (state)
                8'd0, 8'd1: count_end = C4;
                8'd2, 8'd3: count_end = D4;
                8'd4, 8'd5: count_end = C4;
                8'd6, 8'd7: count_end = F4;
                8'd8, 8'd9: count_end = E4;
                
                8'd10, 8'd11: count_end = C4;
                8'd12, 8'd13: count_end = D4;
                8'd14, 8'd15: count_end = C4;
                8'd16, 8'd17: count_end = G4;
                8'd18, 8'd19: count_end = F4;

                8'd20, 8'd21: count_end = C4;
                8'd22, 8'd23: count_end = C5;
                8'd24, 8'd25: count_end = A4;
                8'd26, 8'd27: count_end = F4;
                8'd28, 8'd29: count_end = E4;
                8'd30, 8'd31: count_end = D4;

                8'd32, 8'd33: count_end = A4s;
                8'd34, 8'd35: count_end = A4;
                8'd36, 8'd37: count_end = F4;
                8'd38, 8'd39: count_end = G4;
                8'd40, 8'd41: count_end = F4;

                default: count_end = 16'd0;
            endcase
        end
    end

endmodule
