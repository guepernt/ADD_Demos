//ECE 6370
//David Zhang, 2213233

//This module counts to 50000 based on the clk input. It is part of a nested loop that counts to a total
//of 50,000,000, at which point it will determine that 1 second has passed.

//For simulation purposes, this module will be set to a count of 4. The real number should be set
//back after simulation to be 16'b1100001101010000, minus 1.
module oneSecondTimer(clk, rst, enable, counter_out);
	input clk, enable, rst;
	output counter_out;
	reg counter_out;

	reg [15:0] rollingCounter;
	wire counter_wire;
	parameter OFF = 0, ON = 1;
	reg State;
	countTo100 counter(clk, rst, enable, counter_wire);
	
	always @(posedge clk) begin
		if(rst == 1'b0) begin		//Standard reset block
			rollingCounter <= 0;
			counter_out <= 1'b0;
			State <= OFF;
		end
		else
			case (State) 
				OFF: begin								//Stay at 0 until it detects enable high
					rollingCounter <= 0;
					counter_out <= 0;
					if (enable == 1'b1) begin
						State <= ON;
					end
				end

				ON: begin
					if (enable == 1'b1) begin
						if (counter_wire == 1'b1) begin		//Detects increment from nested timer
							if (rollingCounter == 16'b1100001101001111) begin	//Set back after simulation
								counter_out <= 1'b1;
								rollingCounter <= 0;				//Reaches maximum, roll back to 0 and output a 1.
							end
							else begin
								counter_out <= 1'b0;				//Reaching maximum, just keep incrementing.
								rollingCounter <= rollingCounter + 1'b1;
							end
						end
						else begin
							counter_out <= 1'b0;
						end
					end
					else begin
						State <= OFF;
					end
				end
		
				default: begin
					State <= OFF;
				end
			endcase
	end		
endmodule