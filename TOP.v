module TOP(clk, rs, rw, en, dat, rst, up, dwn, lef, rig, led, seg, buz);
    input up, dwn, lef, rig, rst, clk;
    output [7:0] dat;
    output rs, rw, en;
    output [3:0] led;
    output [6:0] seg;
	 output buz;
    reg [1:0] dir;
    reg [3:0] wall;
    reg [7:0] pos;
    reg [7:0] x;
    reg [7:0] food;

    reg clk_1hz;
    reg e;
    reg [7:0] dat;
    reg rs;
    reg [26:0] counter;
    reg clk_100hz;
    reg [4:0] current, next;
    reg [7:0] rnd = 40;
    reg [14:0] score = 0;
    reg clk_food;
	 reg d;
    reg clk2;

	 reg [7:0] arr1[0:79] = '{default: 8'hff};
    integer y;
	  
    integer n = 0;
    integer m = 0;
	 integer o = 0;
	 reg game_over = 0;
	 
    CLK_1HZ U1 (clk, clk_1hz);
    DISPLAY_7SEG U2 (clk, score, seg, led);
    CLK_100HZ U3 (clk, clk_100hz);
	 sound U4 (clk, buz);
	 RNG U5 (clk_food, rnd);


    reg [7:0] arr[0:79];
    reg [7:0] add;
    integer i;

    initial begin
        add = 8'h80;
        for (i = 0; i < 80; i = i + 1) begin
            arr[i] = add;
            add = add + 1;

            if (add == 8'h94) add = 8'hC0;
            else if (add == 8'hD4) add = 8'h94;
            else if (add == 8'hA8) add = 8'hD4;
        end
    end

    always @(posedge clk_food) begin
        food <= arr[rnd];
        score <= score + 1;
    end

    always @(posedge clk ) begin
    if (rig == 0 && dir != 1) dir <= 0;
    else if (lef == 0 && dir != 0) dir <= 1;
    else if (up == 0 && dir != 3) dir <= 2;
    else if (dwn == 0 && dir != 2) dir <= 3;

        if (x > 0 && x < 18)
            wall <= 0;
        else if (x == 39 || x == 59)
            wall <= 1;
        else if (x > 60 && x < 79)
            wall <= 2;
        else if (x == 20 || x == 40)
            wall <= 3;
        else if (x == 0)
            wall <= 4;
        else if (x == 19)
            wall <= 5;
        else if (x == 60)
            wall <= 6;
        else if (x == 79)
            wall <= 7;
        else
            wall <= 8;
        if (pos == food) begin
            clk_food <= ~clk_food;
        end
		  if (!game_over && score > 3) begin  
        for (o = 1; o < 79; o = o + 1) begin
            if (arr1[o] == pos && o < score)	game_over <= 1;
				if (arr[o] == food && o < score ) clk_food <= ~clk_food;
        end
    end
    end

    always @(posedge clk_1hz) begin
        case (wall)
            0: begin
                case (dir)
                    2'd0: x <= x + 1;
                    2'd1: x <= x - 1;
                    2'd2: x <= x + 60;
                    2'd3: x <= x + 20;
                endcase
            end
            1: begin
                case (dir)
                    2'd0: x <= x - 19;
                    2'd1: x <= x - 1;
                    2'd2: x <= x - 20;
                    2'd3: x <= x + 20;
                endcase
            end
            2: begin
                case (dir)
                    2'd0: x <= x + 1;
                    2'd1: x <= x - 1;
                    2'd2: x <= x - 20;
                    2'd3: x <= x - 60;
                endcase
            end
            3: begin
                case (dir)
                    2'd0: x <= x + 1;
                    2'd1: x <= x + 19;
                    2'd2: x <= x - 20;
                    2'd3: x <= x + 20;
                endcase
            end
            4: begin
                case (dir)
                    2'd0: x <= x + 1;
                    2'd1: x <= x + 19;
                    2'd2: x <= x + 60;
                    2'd3: x <= x + 20;
                endcase
            end
            5: begin
                case (dir)
                    2'd0: x <= x - 19;
                    2'd1: x <= x - 1;
                    2'd2: x <= x + 60;
                    2'd3: x <= x + 20;
                endcase
            end
            6: begin
                case (dir)
                    2'd0: x <= x + 1;
                    2'd1: x <= x + 19;
                    2'd2: x <= x - 20;
                    2'd3: x <= x - 60;
                endcase
            end
            7: begin
                case (dir)
                    2'd0: x <= x - 19;
                    2'd1: x <= x - 1;
                    2'd2: x <= x - 20;
                    2'd3: x <= x - 60;
                endcase
            end
            8: begin
                case (dir)
                    2'd0: x <= x + 7'd1;
                    2'd1: x <= x - 7'd1;
                    2'd2: x <= x - 7'd20;
                    2'd3: x <= x + 7'd20;
                endcase
            end
        endcase
        pos <= arr[x];
		  arr1[0] <= pos;	
            for (y = 79	; y >0; y = y - 1) begin
                    arr1[y] <= arr1[y-1];
                end
	 end
	 
    always @(posedge clk_100hz) begin
        current = next;
        case (current)
            5'd0:  begin rs <= 0; dat <= 8'h38; next <= 5'd1; end
            5'd1:  begin rs <= 0; dat <= 8'h0C; next <= 5'd2; end
            5'd2:  begin rs <= 0; dat <= 8'h6; next <= 5'd3; end
            5'd3:  begin rs <= 0; dat <= 8'h1; next <= 5'd4; end
            5'd4:  begin rs <= 0; dat <= food; next <= 5'd8; end
            5'd8:  begin rs <= 1; dat <= 8'h6F; next <= 5'd5; end
            5'd5:  begin rs <= 0; dat <= pos; next <= 5'd9; end
            5'd9:  begin rs <= 1; dat <= 8'h4F; 
                        if (score != 0) next <= 5'd10; 
                        else next <= 5'd0; 
                   end
            5'd6:  begin
                        if (n < score) begin
                            n <= n + 1;
                            rs <= 0;
                            dat <= arr1[n];
                            next <= 5'd7;
                        end else begin
                            n <= 0;
                            m <= 0;
                            next <= 5'd13;
                        end
                   end
            5'd7:  begin
                        if (m < score) begin  
                            m <= m + 1;
                            rs <= 1;
                            dat <= 8'b11011011;
                            next <= 5'd10;
                        end else begin
                            next <= 5'd13;
                        end
                   end
            5'd10: begin rs <= 1; dat <= 8'h20; next <= 5'd6; end
            5'd13: begin 
                        if (game_over) next <= 5'd12;
                        else next <= 5'd0;
                   end
            5'd12: begin rs <= 0; dat <= 8'h1; next <= 5'd14;  end
            5'd14: begin rs <= 0; dat <= arr[5]; next <= 5'd15; end
            5'd15: begin rs <= 1; dat <= "G"; next <= 5'd16;  end
            5'd16: begin rs <= 1; dat <= "a"; next <= 5'd17;  end
            5'd17: begin rs <= 1; dat <= "m"; next <= 5'd18;  end
            5'd18: begin rs <= 1; dat <= "e"; next <= 5'd19; end
            5'd19: begin rs <= 1; dat <= " "; next <= 5'd20; end
            5'd20: begin rs <= 1; dat <= "O"; next <= 5'd21; end
            5'd21: begin rs <= 1; dat <= "v"; next <= 5'd22; end
            5'd22: begin rs <= 1; dat <= "e"; next <= 5'd23; end
            5'd23: begin rs <= 1; dat <= "r"; next <= 5'd24; end
            5'd24: begin rs <= 0; end
        endcase
    end
    
    assign en = clk_100hz | e;
    assign rw = 0;
endmodule

