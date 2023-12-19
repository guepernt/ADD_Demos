//ECE 6370
//David Zhang
//Testbench

//This is a testbench. Do you really need a description?
`timescale 1 ns/100 ps
module tb_RNGProject ();
	reg clk, rst, fetch_request;
	wire [3:0] D1000, D100, D10, D1;
	
	RNG_Project DUT(fetch_request, D1000, D100, D10, D1, clk, rst);
	always
		begin	
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end 
	initial
	begin
		rst = 1; fetch_request = 0;
		#5 rst = 0;
		@(posedge clk);
		#5 rst = 1;
		#100;
		#5 fetch_request = 1;
		@(posedge clk);
		#5 fetch_request = 0;
		#130; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#72; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#479; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#246; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#200; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#120; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
		#30; #5 fetch_request = 1; @(posedge clk); #5 fetch_request = 0;
	end
endmodule
