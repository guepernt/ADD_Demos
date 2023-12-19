//ECE 6370
//Author: David Zhang, 3233
//Access Controller Module, Lab 3

//This module defines the modified access controller for the mental binary game, which replaces the logout feature and button
//with a button to load 99 seconds into the timer and start the subsequent game. After the timer reaches 0, all features are 
//locked out until the button is pushed again to add 99 seconds, then pushed again to start a new round. 

module AccessController(passIn, passButton, loggedIn, loggedOut, p1loadIn, p2loadIn, p1loadOut, p2loadOut, rst, clk, timer_reconfig, timer_enable, time_out, score_enable);
	input [3:0] passIn;
	input passButton, p1loadIn, p2loadIn, rst, clk;
	input time_out;
	output timer_reconfig, timer_enable, score_enable;
	output loggedIn, loggedOut, p1loadOut, p2loadOut;
	reg loggedIn, loggedOut, p1loadOut, p2loadOut, timer_reconfig, timer_enable, score_enable;

	parameter DIGIT0 = 0, DIGIT1 = 1, DIGIT2 = 2, DIGIT3 = 3, VERIFY = 4, RECONFIG_TIMER = 5;	//Rename of some states to match up with FSM
	parameter PREGAMESTART = 6, GAMEINPROGRESS = 7, GAMEOVER = 8;					//Importantly these states are needed for new operation.
	reg passwordRight;
	reg[3:0] State;

	always@(posedge clk) begin
		if (rst == 1'b0) begin						//Reset of all signals.
			State <= DIGIT0;
			passwordRight <= 1'b1;
			p1loadOut <= 1'b0;
			p2loadOut <= 1'b1;						//Default is high for a pushbutton.
			loggedIn <= 1'b0;
			loggedOut <=1'b1;
			timer_enable <= 1'b0;
			timer_reconfig <= 1'b0;
			score_enable <= 1'b0;
			end
		else 
			case(State) 
				DIGIT0: begin					//Setting all signals to correct baseline
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b1;			
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
						State <= RECONFIG_TIMER;	//been entered correctly up to this stage.
					end
					else
						State <= DIGIT0;
				end

				RECONFIG_TIMER: begin
					//p1loadOut <= p1loadIn;	//Player inputs must still be blocked at this stage. 
					//p2loadOut <= p2loadIn;
					loggedIn <= 1'b1;
					loggedOut <= 1'b0;
					timer_reconfig <= 1'b1;		//Add to timers and immediately move to next state
					score_enable <= 1'b0;		//Turn off score when starting new round. 
					State <= PREGAMESTART;		
					//if (passButton == 1'b1)begin 	//Implementation of logout function, no longer needed.
					//	State <= DIGIT0;
					//end

				end

				PREGAMESTART: begin
					timer_reconfig <= 1'b0;
					if (passButton == 1'b1) begin	//Ensures reconfig is high for only 1 cycle and waits till button is pressed.
						timer_enable <= 1'b1;
						State <= GAMEINPROGRESS;//If button pressed, timer starts going down and move into gameplay phase. 
					end
				end

				GAMEINPROGRESS: begin
					p1loadOut <= p1loadIn;
					p2loadOut <= p2loadIn; 	//Finally player inputs are unblocked, game works as usual.
					if (time_out == 1'b1) begin
						State <= GAMEOVER;	//Moves to Game Over once it detects active high time out signal (noBorrow)
					end
				end

				GAMEOVER: begin
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b1;		//Blocks all player inputs again.
					timer_enable <= 1'b0;		//Turn off countdown.
					score_enable <= 1'b1;		//Turn on score to switch MUX output (bonus Feature)
					if (passButton == 1'b1) begin
						State <= RECONFIG_TIMER;//Move to reconfig whenever game button is pressed.
					end
				end

				default: begin
					loggedIn <= 1'b0;
					loggedOut <= 1'b1;
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b1;		
					timer_enable <= 1'b0;
					timer_reconfig <= 1'b0;
					score_enable <= 1'b0;
					State <= DIGIT0;
				end

			endcase
	end

endmodule

