//ECE 6370
//David Zhang, 2213233
//Game Controller Module

//This module defines the GameController half of the Access Controller. It takes in a long active high enable signal from the
//Authentication half to start operation. It loads 99 seconds into the timer displays and blocks all player inputs until the
//Game Start button has been pushed. Insert stuff about logout here, when done. After 99 seconds have run out, the system goes
//to the Game Over state where it turns on the score display, showing the amount of correct matches that the player did. 

module GameController(enable, passButton, p1loadIn, p2loadIn, p1loadOut, 
		      p2loadOut, rst, clk, timer_reconfig, timer_enable, time_out, score_enable, logout_s, passReset);
	input enable;
	input passButton, p1loadIn, p2loadIn, rst, clk;
	input time_out;
	output timer_reconfig, timer_enable, score_enable;
	output p1loadOut, p2loadOut;
	output logout_s, passReset;						//New output signals for logging out and resetting password.
	reg p1loadOut, p2loadOut, timer_reconfig, timer_enable, score_enable;

	parameter DIGIT0 = 0, DIGIT1 = 1, DIGIT2 = 2, DIGIT3 = 3, VERIFY = 4, RECONFIG_TIMER = 5;	//Rename of some states to match up with FSM
	parameter PREGAMESTART = 6, GAMEINPROGRESS = 7, GAMEOVER = 8;					//Importantly these states are needed for new operation.
	parameter WAIT = 9; 							//New starting state since AccessController split
	reg passwordRight;
	reg[3:0] State;
	reg logout_s, passReset;
	reg[2:0] wait_timer; 							//Arbitrarily long wait timer for initial state

	always @(posedge clk) begin
		if (rst == 1'b0) begin						//Reset of all signals.
			State <= WAIT;
			passwordRight <= 1'b1;
			p1loadOut <= 1'b0;
			p2loadOut <= 1'b1;						//Default is high for a pushbutton.
			timer_enable <= 1'b0;
			timer_reconfig <= 1'b0;
			score_enable <= 1'b0;
			logout_s <= 1'b0;
			passReset <= 1'b0;
			wait_timer <= 0;
			end
		else begin
			case(State)
				WAIT: begin			//Needs to wait some clock cycles for enable to update--necessary for logout and passreset function.
					if (wait_timer != 2'b11) begin
						wait_timer <= wait_timer + 1'b1;	//This happens in <1 us regardless, so arbitrary for human perception
					end
					else begin
						if (enable == 1'b1) begin
							State <= RECONFIG_TIMER;
						end
					end
				end
				RECONFIG_TIMER: begin
					wait_timer <= 0;
					//p1loadOut <= p1loadIn;	//Player inputs must still be blocked at this stage. 
					//p2loadOut <= p2loadIn;
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
					if (p2loadIn == 1'b1) begin	//p2 is analog to RNG
						passReset <= 1'b1;
						State <= WAIT;
					end
					if (p1loadIn == 1'b1) begin	//Player Load button is logout
						logout_s <= 1'b1;
						State <= WAIT;
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
						State <= WAIT;		//Move to start whenever game button is pressed.
					end
					if (p2loadIn == 1'b1) begin
						passReset <= 1'b1;
						State <= WAIT;
					end
					if (p1loadIn == 1'b1) begin
						logout_s <= 1'b1;
						State <= WAIT;
					end
				end

				default: begin
					State <= WAIT;
					passwordRight <= 1'b1;
					p1loadOut <= 1'b0;
					p2loadOut <= 1'b1;			//Default is high for a pushbutton.
					timer_enable <= 1'b0;
					timer_reconfig <= 1'b0;
					score_enable <= 1'b0;
					logout_s <= 1'b0;
					passReset <= 1'b0;
					wait_timer <= 0;
				end

			endcase
		end
	end
endmodule
