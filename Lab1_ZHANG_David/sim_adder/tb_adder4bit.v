`timescale 1 ns/100 ps;
module tb_adder4bit ();

	reg [3:0] adder_in1, adder_in2;
	wire [3:0] sum_s;

	Adder4Bit DUT(adder_in1, adder_in2, sum_s);

	initial
		begin
			adder_in1 = 4'b0001; adder_in2 = 4'b0010; //1 + 2, expect 3
			#10
			adder_in1 = 4'b1100; adder_in2 = 4'b0011; //12 + 3, expect 15
			#10
			adder_in1 = 4'b1110; adder_in2 = 4'b0111; //overflow, expect...5?
			#10;
		end
endmodule
