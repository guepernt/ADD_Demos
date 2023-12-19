//ECE 6370
//David Zhang, 2213233

//This module serves as an improved version of the old 1 second Timer by using an LFSR instead of binary
//counting. Since the LFSR does not count in a linear fashion (1,2,3...) the termination point must 
//be determined from a comparison simulation with the old 1 second Timer. Through simulation, this value
//was found to be decimal 37449, or binary 1001001001001001

module oneSecondLFSR(clk, rst, enable, counter_out);
	input clk, enable, rst;
	output counter_out;
	reg counter_out;

	//reg [15:0] rollingCounter;
	wire counter_wire;
	parameter OFF = 0, ON = 1;
	reg State;
	countTo100 counter(clk, rst, enable, counter_wire);
 	reg [15:0] LFSR;
 	wire feedback = LFSR[15];	//New parts for LFSR
	
	always @(posedge clk) begin
		if(rst == 1'b0) begin		//Standard reset block
			LFSR <= 0;
			counter_out <= 1'b0;
			State <= OFF;
		end
		else
			case (State) 
				OFF: begin								//Stay at 0 until it detects enable high
					LFSR <= 0;
					counter_out <= 0;
					if (enable == 1'b1) begin
						State <= ON;
					end
				end

				ON: begin
					if (enable == 1'b1) begin
						if (counter_wire == 1'b1) begin		//Detects increment from nested timer
							if (LFSR == 16'b1001001001001001) begin	//Set back after simulation
								counter_out <= 1'b1;
								LFSR <= 0;				//Reaches maximum, roll back to 0 and output a 1.
							end
							else begin
								counter_out <= 1'b0;				//Reaching maximum, just keep incrementing.
								LFSR[0] <= feedback;
    								LFSR[1] <= LFSR[0];
    								LFSR[2] <= LFSR[1] ~^ feedback;
  								LFSR[3] <= LFSR[2] ~^ feedback;
								LFSR[4] <= LFSR[3];
  								LFSR[5] <= LFSR[4] ~^ feedback;
    								LFSR[6] <= LFSR[5];
    								LFSR[7] <= LFSR[6];
    								LFSR[8] <= LFSR[7];
    								LFSR[9] <= LFSR[8];
    								LFSR[10] <= LFSR[9];
    								LFSR[11] <= LFSR[10];
    								LFSR[12] <= LFSR[11];
    								LFSR[13] <= LFSR[12];
    								LFSR[14] <= LFSR[13];
    								LFSR[15] <= LFSR[14];
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
