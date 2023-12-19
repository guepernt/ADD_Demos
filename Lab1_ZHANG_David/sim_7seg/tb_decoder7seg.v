`timescale 1 ns/100 ps;
module tb_decoder7seg ();
	
	reg [3:0] decoderin_s;
	wire [6:0] decoderout_s;

	Decoder7Seg DUT_7SD(decoderin_s, decoderout_s);

	initial 
		begin
		decoderin_s = 4'b0000; 
		#10 decoderin_s = 4'b0101;
		#10 decoderin_s = 4'b1111;
		end

endmodule