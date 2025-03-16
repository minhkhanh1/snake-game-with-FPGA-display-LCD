module DISPLAY_7SEG (
    input clk,
    input [13:0] so,
    output reg [6:0] seg,
    output reg [3:0] an
);

reg [15:0] clk_div;
reg  scan;
reg [3:0] digit;

always @(posedge clk) begin
    clk_div <= clk_div + 1;
end
wire slow_clk = clk_div[15];

wire [3:0] nghin, tram, chuc, dvi;
assign dvi   = so % 10;
assign chuc  = (so / 10) ;
assign tram  = (so / 100) ;
assign nghin = (so / 1000) ;

function [6:0] seg_decode;
    input [3:0] num;
    case (num)
        4'h0: seg_decode = 7'b1000000;
        4'h1: seg_decode = 7'b1001111;
        4'h2: seg_decode = 7'b0100100;
        4'h3: seg_decode = 7'b0000110;
        4'h4: seg_decode = 7'b0001011;
        4'h5: seg_decode = 7'b0010010;
        4'h6: seg_decode = 7'b0010000;
        4'h7: seg_decode = 7'b1000111;
        4'h8: seg_decode = 7'b0000000;
        4'h9: seg_decode = 7'b0000010;
        default: seg_decode = 7'b1111111;
    endcase
endfunction

always @(posedge slow_clk) begin
    scan <= scan + 1;
end

always @(posedge slow_clk) begin
    case (scan)
        2'b00: begin an = 4'b1110; digit = chuc; end
        2'b01: begin an = 4'b1101; digit = dvi; end
        2'b10: begin an = 4'b1011; digit = tram; end
        2'b11: begin an = 4'b0111; digit = nghin; end
        default: begin an = 4'b1111; digit = 4'h0; end
    endcase
end

always @(posedge slow_clk) begin
    seg <= seg_decode(digit);
end

endmodule