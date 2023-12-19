//ECE 6370 
//David Zhang
//RNG Module using 16-bit LFSR

//This module handles the RNG portion 

module RNG_Project(fetch_num, D1000, D100, D10, D1, clk, rst);
	input fetch_num, clk, rst;
	output [3:0] D1000, D100, D10, D1;

	reg [3:0] D1000, D100, D10, D1;
  	reg [15:0] LFSR;
  	wire feedback = LFSR[15] ^ (LFSR[14:0]==15'b111111111111111);

	always @(posedge clk) begin
		if (rst == 1'b0) begin
			D1000 = 0;
			D100 = 0;
			D10 = 0;
			D1 = 0;	
			LFSR = 0;	
		end
		else begin
			LFSR[0] <= feedback;
    			LFSR[1] <= LFSR[0];
    			LFSR[2] <= LFSR[1] ~^ feedback;
    			LFSR[3] <= LFSR[2] ~^ feedback;
   			LFSR[4] <= LFSR[3];
    			LFSR[5] <= LFSR[4] ~^ feedback;
    			LFSR[6] <= LFSR[5];
    			LFSR[7] <= LFSR[6];
   			LFSR[8] <= LFSR[7];
    			LFSR[9] <= LFSR[8];
   			LFSR[10] <= LFSR[9];
    			LFSR[11] <= LFSR[10];
    			LFSR[12] <= LFSR[11];
    			LFSR[13] <= LFSR[12];
    			LFSR[14] <= LFSR[13];
    			LFSR[15] <= LFSR[14];
			if (fetch_num == 1'b1) begin
				D1000 <= LFSR[15:12]*0.625;
				D100 <= LFSR[11:8]*0.625;
				D10 <= LFSR[7:4]*0.625;
				D1 <= LFSR[3:0]*0.625;
			end
		end
	end
endmodule
