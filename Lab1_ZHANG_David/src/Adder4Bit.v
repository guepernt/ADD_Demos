module Adder4Bit (adder_in1, adder_in2, sum);
	input [3:0] adder_in1, adder_in2;
	output [3:0] sum;
	reg [3:0] sum;

	always @(adder_in1, adder_in2) begin
		sum = adder_in1 + adder_in2;

	end



endmodule
