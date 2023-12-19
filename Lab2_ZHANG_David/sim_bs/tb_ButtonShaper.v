`timescale 1 ns/100 ps
module tb_ButtonShaper();
	reg clk;
	reg rst, D_in;
	wire Q_out;

	always
	begin	
		clk = 1'b0;
		#10;
		clk = 1'b1;
		#10;
	end
	
	ButtonShaper DUT_BS(D_in, Q_out, rst, clk);

	initial
	begin
		rst = 1'b1;
		D_in = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 rst = 1'b0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 rst = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 D_in = 1'b0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 D_in = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 D_in = 1'b0;
		@(posedge clk);
		@(posedge clk);
		#5 D_in = 1'b1;
	end

endmodule
