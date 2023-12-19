//ECE 6370
//David Zhang
//Scoring Module Test Bench

//Insert flavor text here
`timescale 1 ns/ 100 ps
module tb_Scoring();
	reg clk, rst, score_request;
	reg [4:0] playerID;
	reg [6:0] score;

	wire pwinner, valid, WRen;
	wire [6:0] toRAM, fromRAM;
	wire [4:0] RAMaddr, gwinner;
	wire [3:0] D10, D1;

	Scoring DUT(score_request, playerID, score, pwinner, gwinner, valid, WRen, toRAM, fromRAM, RAMaddr, D10, D1, clk, rst);	
	RAM_Scoring RAM(RAMaddr, clk, toRAM, WRen, fromRAM);	

	
	always
		begin	
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end 
	initial
	begin
		playerID = 0; score = 0; score_request = 0;
		#5 rst = 0; @(posedge clk); #5 rst = 1;
	 	#3000; 							//Wait long time for RAM initialize to finish.
		#5 playerID = 1; score = 15; score_request = 1;
		@(posedge clk);	
		#5 score_request = 0;
		#300;							//Wait long time and see if valid signals ever go high. 
		#5 playerID = 2; score = 70; score_request = 1;
		@(posedge clk);
		#5 score_request = 0;					//Should see new address change and pwinner, but not gwinner.
		#300; 
		#5 playerID = 3; score = 80; score_request = 1;		//Guest Player, should not see pwinner. Should see gwinner.
		@(posedge clk);
		#5 score_request = 0;					//Should not see WRen go high, not a high score for this player. 
	end
endmodule