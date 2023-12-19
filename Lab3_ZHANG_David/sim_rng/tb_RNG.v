//ECE 6370
//David Zhang, 2213233
//Testbench for RNG Module

//This module defines the testbench used for testing the RNG module. Since control of the input signal is 
//done through the access controller, there is no enable for this module. It tests whether it can steadily
//increment through its internal register for every clock cycle that input is held active low.
`timescale 1 ns/100 ps
module tb_RNG();
	reg buttonPush, clk, rst;
	wire [3:0] RNGOut;
	RNG DUT(buttonPush, clk, rst, RNGOut);
	
	always
		begin	
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end 
	initial 
	begin
		rst = 1'b1;
		buttonPush = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 rst = 1'b0;
		@(posedge clk);
		#5 rst = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);

		#5 buttonPush = 1'b0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 buttonPush = 1'b1; 	//4 clk cycles active, should expect 3.

		@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);
		#5 buttonPush = 1'b0; 	//Should not advance while signal is high.
		@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);
		@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);
		@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);

		@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);
		#5 buttonPush = 1'b1; 	//Should roll back to 0.
	end

endmodule
