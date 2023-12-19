module ButtonShaper (D, Q, rst, clk);
	input D, rst, clk;
	output Q;
	reg Q;
	parameter INIT = 0, PULSE = 1, WAIT = 2;
	
	reg[2:0] State, StateNext;

	//CombLogic
	always @(State, D) begin
		case (State)
			INIT: begin
				Q = 1'b0;
				if (D == 1'b0)
					StateNext = PULSE;
				else
					StateNext = INIT;
			end
			PULSE: begin
				Q = 1'b1;
				StateNext = WAIT;
			end
			WAIT: begin
				Q = 1'b0;
				if (D == 1'b1)
					StateNext = INIT;
				else
					StateNext = WAIT;
			end
			default: begin
				Q = 1'b0;
				StateNext = INIT;
			end
		endcase
	end

	// Sequential Logic
	always@(posedge clk) begin 
		if (rst == 1'b0) 
			State <= INIT;
		else 
			State <= StateNext;
	end
	

endmodule
