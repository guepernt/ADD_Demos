`timescale 1 ns/ 100 ps
module tb_LoadRegister();
	reg clk;
	reg rst, Load;
	reg [3:0] D_in;
	wire [3:0] D_out;

	always
	begin	
		clk = 1'b0;
		#10;
		clk = 1'b1;
		#10;
	end
	
	LoadRegister LR1 (D_in, D_out, clk, rst, Load);

	initial
	begin
		rst = 1'b1;
		Load = 1'b0;
		D_in = 4'b000;
		@(posedge clk);
		@(posedge clk);
		#5 rst = 1'b0;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 rst = 1'b1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		D_in = 4'b0001;
		@(posedge clk);
		Load = 1'b1;
		@(posedge clk);
		Load = 1'b0;
		@(posedge clk);
		D_in = 4'b1111;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		D_in = 4'b0111;
		@(posedge clk);
		@(posedge clk);
		Load = 1'b1;
		@(posedge clk);
		Load = 1'b0;
		@(posedge clk);
	end
endmodule	