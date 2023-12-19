module Lab1_ZHANG_David (P1INPUT, P2INPUT, P1DISPLAY, P2DISPLAY, SUMDISPLAY, LED_L, LED_R);
	
	input [3:0] P1INPUT, P2INPUT;
	output [6:0] P1DISPLAY, P2DISPLAY, SUMDISPLAY;
	output LED_L, LED_R;
	wire [6:0] P1DISPLAY, P2DISPLAY, SUMDISPLAY;	
	reg LED_L, LED_R;
	wire [3:0] AdderOutput;

	Decoder7Seg Player1Decoder(P1INPUT, P1DISPLAY);
	Decoder7Seg Player2Decoder(P2INPUT, P2DISPLAY);
	Decoder7Seg TotalSum(AdderOutput, SUMDISPLAY);
	Adder4Bit SumAdder(P1INPUT, P2INPUT, AdderOutput);

	always @ (P1INPUT, P2INPUT) begin
		if (AdderOutput == 4'b1111) 
			begin
				LED_L = 0; LED_R = 1;
			end
		else 
			begin
				LED_L = 1; LED_R = 0;
			end
	end
endmodule
