module CLK_100HZ(clk_ht, clk_1hz);

input clk_ht;                
output clk_1hz;          
reg clk_1hz = 0;
reg [26:0] counter = 0;  
always @ (posedge clk_ht)  
    begin
    counter <= counter + 1;
        if (counter == 26'd500000)          
            begin    
                    counter <= 0;
                    clk_1hz <= ~clk_1hz;    
            end
        else
            clk_1hz <= clk_1hz;
    end

endmodule