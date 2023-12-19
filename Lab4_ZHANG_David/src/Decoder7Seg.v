module Decoder7Seg(decoderin, decoderout);
	input [3:0] decoderin;	
	output [6:0] decoderout;
	reg [6:0] decoderout;
	always @ (decoderin) begin
		case (decoderin)
			4'b0000: begin decoderout = 7'b1000000; end //0
			4'b0001: begin decoderout = 7'b1111001; end //1
			4'b0010: begin decoderout = 7'b0100100; end //2
			4'b0011: begin decoderout = 7'b0110000; end //3
			4'b0100: begin decoderout = 7'b0011001; end //4
			4'b0101: begin decoderout = 7'b0010010; end //5
			4'b0110: begin decoderout = 7'b0000010; end //6
			4'b0111: begin decoderout = 7'b1111000; end //7
			4'b1000: begin decoderout = 7'b0000000; end //8 
			4'b1001: begin decoderout = 7'b0011000; end //9
			4'b1010: begin decoderout = 7'b0001000; end //A
			4'b1011: begin decoderout = 7'b0000011; end //B
			4'b1100: begin decoderout = 7'b1000110; end //C
			4'b1101: begin decoderout = 7'b0100001; end //D
			4'b1110: begin decoderout = 7'b0000110; end //E
			4'b1111: begin decoderout = 7'b0001110; end //F
			default: begin decoderout = 7'b1111111; end //fail state
		endcase
	end
endmodule