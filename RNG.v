module RNG (
    input clock,
    output reg [7:0] rnd
);

reg [6:0] random = 7'b1010101;  
wire feedback = random[6] ^ random[5]; 

always @(posedge clock) begin
    random <= {random[5:0], feedback}; 
    rnd <= {1'b0, random} % 80; 
end

endmodule
