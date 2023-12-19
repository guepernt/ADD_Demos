//ECE 6370
//Author: David Zhang, 3233
//Access Controller Module

//This module defines the access controller for the mental binary game, which implements a log-in feature using player
//2's switches. Password is arbitrary, but for simplicity is last 4 digits of ID so 3233 in this case. It should prevent
//player's from playing the game before they have been correctly verified by entering in the correct password. 

module AccessController(passIn, passButton, loggedIn, loggedOut, p1loadIn, p2loadIn, p1loadOut, p2loadOut, rst, clk);
	input [3:0] passIn;
	input passButton, p1loadIn, p2loadIn, rst, clk;
	output loggedIn, loggedOut, p1loadOut, p2loadOut;
	reg loggedIn, loggedOut, p1loadOut, p2loadOut;

	parameter DIGIT0 = 0, DIGIT1 = 1, DIGIT2 = 2, DIGIT3 = 3, VERIFY = 4, OPERATIONAL = 5;
	reg passwordRight;
	reg[2:0] State;

	always@(posedge clk) begin
		if (rst == 1'b0) begin						//Reset of all signals.
			State <= DIGIT0;
			passwordRight <= 1'b1;
			p1loadOut <= 1'b0;
			p2loadOut <= 1'b0;
			loggedIn <= 1'b0;
			loggedOut <=1'b1;
			end
		else 
			case(State) 
				DIGIT0: begin					//Setting all signals to correct baseline
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b0;
					passwordRight <= 1'b1;
					loggedIn <= 1'b0;
					loggedOut <=1'b1;
					if (passButton == 1'b1)begin 		//Operation should ONLY proceed whenever
						if (passIn == 4'b0011)begin	//the pushbutton is depressed.
							State <= DIGIT1;
						end
						else
							passwordRight <= 1'b0;
							State <= DIGIT1;
					end
												
				end

				DIGIT1: begin
					if (passButton == 1'b1)begin 
						if (passIn == 4'b0010)begin
							State <= DIGIT2;
						end
						else
							passwordRight <= 1'b0;
							State <= DIGIT2;
					end
				end
			
				DIGIT2: begin
					if (passButton == 1'b1)begin
						if (passIn == 4'b0011)begin
							State <= DIGIT3;
						end
						else
							passwordRight <= 1'b0;
							State <= DIGIT3;
					end
				end

				DIGIT3: begin
					if (passButton == 1'b1)begin 
						if (passIn == 4'b0011)begin
							State <= VERIFY;
						end
						else
							passwordRight <= 1'b0;
							State <= VERIFY;
					end
				end

				VERIFY: begin
					if (passwordRight == 1'b1)begin	//Verification check. All numbers should have
						State <= OPERATIONAL;	//been entered correctly up to this stage.
					end
					else
						State <= DIGIT0;
				end

				OPERATIONAL: begin
					p1loadOut <= p1loadIn;
					p2loadOut <= p2loadIn;
					loggedIn <= 1'b1;
					loggedOut <= 1'b0;
					if (passButton == 1'b1)begin 	//Implementation of logout function
						State <= DIGIT0;
					end

				end
				default: begin
					loggedIn <= 1'b0;
					loggedOut <= 1'b1;
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b0;
					State <= DIGIT0;
				end

			endcase
	end

endmodule

