//ECE 6370
//David Zhang, 2213233
//Random Number Generator Module

//This module defines the Random Number Generator. It takes in a 1-bit active low signal from a push button
//and increments an internal register every clock cycle that it detects this active low signal. This input
//is not shaped, and thus how long a player pushes down on the button can be used for RNG. After it detects 
//that input has gone high again, outputs the current value stored within the register.

module RNG(rngIn, clk, rst, rngOut);
	input rngIn, clk, rst;
	output [3:0] rngOut;
	reg [3:0] rngOut;


	always @(posedge clk) begin
		if (rst == 1'b0) begin
			rngOut <= 0;
		end
		else if (rngIn == 1'b0) begin	//Unshaped signal, so active signal low.
			rngOut <= rngOut + 1'b1;	
		end
	end
endmodule
