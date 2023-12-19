//ECE6370
//Author: Jay Choe
//Module name: ButtonShaper
//This module ensures the inputs are count only one cycle time 
//regardless of the button press duration. 

module ButtonShaper(clk, rst, in, out);
	input in, clk, rst;
	output reg out;
	reg[1:0] curState,nextState;

	parameter INIT = 0, PULSE = 1, WAIT = 2;

        initial begin
	    out = 1'b0;
            curState = INIT;
	end
	always@(posedge clk) begin
		case(curState) 
		    INIT: begin
			out = 1'b0;
			if(in == 1'b0)
			    nextState = PULSE;
			else
			    nextState = INIT;
		    end
		    PULSE: begin
			out = 1'b1;
			nextState = WAIT;
		    end
		    WAIT: begin
			out = 1'b0;
			if(in == 1'b1) 
			    nextState = INIT;
			else
			    nextState = WAIT;
		    end
		    default: begin
			out = 1'b0;
			nextState = INIT;
		    end
		endcase
	end

	always@(posedge clk) begin
	    if(rst == 1'b0)
		curState <= INIT;
	    else
	        curState <= nextState;
	end

endmodule

