module AccessController(clk, reset, input_data, ID_digit, pass_digit, load, difficulty_in, Timeout, 
						ID_addr, pass_addr, logged_in, logged_out, is_guest, difficulty, Reconfig, enable, 
						RNG_Gen_In, RNG_Gen_Out, player_num);
    input clk, reset;
	input [3:0] input_data;
	input [3:0] ID_digit;
    input [3:0] pass_digit;
    input load, difficulty_in, Timeout;
	input RNG_Gen_In;
    output reg [5:0] ID_addr;
    output reg [5:0] pass_addr;
    output reg logged_in, logged_out, is_guest, Reconfig, enable;
	output reg [3:0] difficulty;
	output reg RNG_Gen_Out;
    output reg [4:0] player_num;

    reg[3:0] State;
    reg[2:0] ID_count;
    reg[2:0] pass_count;
    reg[1:0] cycle;
    reg ID_passed;
	reg [15:0] fetched_IDs;
    reg [15:0] input_ID;
	reg [2:0] idx;
    reg [2:0] size;
	

    parameter Wait = 0, Fetch = 1, Cycle = 2, GetID = 3, Compare = 4, ID_verified = 5, Authenticated = 6, 
			setDifficulty = 7, setTimer = 8, GameStart = 9, GameOver = 11, Reset = 12, tmp = 13, tmp2 = 14, tmp3 = 15;

    initial begin
		State <= Wait;
		ID_addr <= 6'b111000;
        pass_addr <= 6'b111000;
		logged_in <= 1'b0;
		logged_out <= 1'b1;
        ID_count <= 3'b000;
		pass_count <= 3'b000;
		cycle <= 2'b10;
		ID_passed <= 1'b0;
		idx <= 3'b011;
		size <= 3'b000;
		player_num <= 3'b000;
		is_guest <= 1'b0;
	    fetched_IDs <= 0;
        input_ID <= 0;
		difficulty <= 4'b0000;
		Reconfig <= 1'b0;
		enable <= 1'b0;
    end

    always@(posedge clk) begin
	if(reset == 1'b0) begin
	    State <= Wait;
		ID_addr <= 6'b111000;
        pass_addr <= 6'b111000;
	    logged_in <= 1'b0;
		logged_out <= 1'b1;
        ID_count <= 3'b000;
		pass_count <= 3'b000;
		ID_passed <= 1'b0;
		cycle <= 2'b10;
		idx <= 3'b011;
		size <= 3'b000;
		player_num <= 3'b000;
		is_guest <= 1'b0;
		fetched_IDs <= 0;
        input_ID <= 0;
		difficulty <= 4'b0000;
		Reconfig <= 1'b0;
		enable <= 1'b0;
	end
	else begin
	    case(State)
		tmp: begin
			State <= Wait;
		end
		tmp2: begin
			State <= setDifficulty;
		end
		tmp3: begin
			State <= GameStart;
		end
		Wait: begin
			//if 4-digit input ID is taken, start fetch ID from ROM
			if(size >= 3'b100) begin
				size <= 3'b000;
				idx <= 3'b011;
				State <= Fetch;
			end
			else if(load == 1'b1) begin
				if(ID_passed == 1'b0) begin
					//get full user ID input
					input_ID[4*idx +:3] <= input_data;
					idx <= idx - 1'b1;
					size <= size + 1'b1;
					State = tmp;
				end
				else begin
					State <= Fetch;
				end
		    end
		    else begin
				State <= Wait;
		    end
		end
		Fetch: begin
		    if(ID_passed == 1'b1) begin
		        pass_addr <= pass_addr + 4'b1000;
				cycle <= 2'b10;
				State <= Cycle;
		    end
		    else begin
				ID_addr <= ID_addr + 4'b1000;
				cycle <= 2'b10;
				State <= Cycle;
		    end
		end
		Cycle: begin
				//Get data from ROM and takes two cycles
				if(cycle > 1'b0) begin
					cycle <= cycle - 1;
					State <= Cycle;
				end
				else if(ID_passed == 1'b0) begin
					State <= GetID;
				end
				else begin
					State <= Compare;
				end
		end
		GetID: begin
			//Stored Rom ID to a buffer
			fetched_IDs[4*idx+:3] <= ID_digit;
			idx <= idx - 1'b1;
			if(idx == 3'b111) begin
				State <= Compare;
			end 
			else begin
				State <= Fetch;
			end		
		end
		Compare: begin
		    if(ID_passed == 1'b0) begin
				ID_passed = (input_ID == fetched_IDs);
				if(ID_passed == 1'b1) begin
					if(player_num == 3'b011) begin
						is_guest <= 1'b1;
						State <= Authenticated;
					end
					else begin
						//To specify whther the user is ID verified.
						logged_in <= 1'b0;
						logged_out <= 1'b0;
						size <= 3'b000;
						idx <= 3'b011;
						//Adjust the password address entry according to the player number.
						pass_addr <= pass_addr + player_num;
						State <= Wait;
					end
				end
				else begin//compare with the different ID
					if(player_num >= 3'b011) begin
						//User info not found, go back to the initial state
						State <= Reset;
					end
					else begin
						player_num <= player_num + 1'b1;
						ID_addr <= 6'b111000 + player_num + 1'b1;
						fetched_IDs <= 0;
						idx <= 3'b011;
						size <= 3'b000;
						State <= Fetch;
					end
				end
		    end
		    //ID already verified, check password
		    else begin
		        if(pass_digit == input_data) begin//correct password 
					if(pass_count >= 3'b101) begin
						State <= Authenticated;
					end
					else begin
						pass_count <= pass_count + 1;
						State <= Wait;
					end
		        end
		    end
		end
		Authenticated: begin
			logged_in <= 1'b1;
			logged_out <= 1'b0;
			difficulty <= 4'b0000;
			State <= setDifficulty;
		end
		setDifficulty: begin
			Reconfig <= 1'b0;
			if(difficulty_in == 1'b1) begin
				if(difficulty >= 4'b0010) begin
					difficulty <= 4'b0000;
					Reconfig <= 1'b1;
					State <= tmp2;
				end
				else begin
					difficulty <= difficulty + 1'b1;
					Reconfig <= 1'b1;
					State <= tmp2;
				end
			end
			if(load == 1'b1) begin
				State <= GameStart;
			end
		end
		//setTimer: begin
			//if(load == 1'b1) begin
				//State <= GameStart;
			//end
			//else begin
				//State <= setTimer;
			//end
		//end
		GameStart: begin
			enable <= 1'b1;
			Reconfig <= 1'b0;
			RNG_Gen_Out <= 1'b0;
			//Timeout is inverse logic!!
			//Timeout == 1'b0: time is up
			//Timeout == 1'b1: timer is still running
			if(Timeout == 1'b0) begin
				State <= GameOver;
			end
			else begin
				if(RNG_Gen_In == 1'b1) begin
					RNG_Gen_Out <= 1'b1;
				end
				State <= GameStart;				
			end
		end
		GameOver: begin
			enable <= 1'b0;
			//restar the game
			if(load == 1'b1) begin
				State <= setDifficulty;
			end
			//log out
			else if(difficulty_in == 1'b1) begin
				State <= Reset;
			end
			else begin
				State <= GameOver;
			end
		end
		Reset: begin
			State <= Wait;
			ID_addr <= 6'b111000;
			pass_addr <= 6'b111000;
			logged_in <= 1'b0;
			logged_out <= 1'b1;
			ID_count <= 3'b000;
			pass_count <= 3'b000;
			cycle <= 2'b10;
			ID_passed <= 1'b0;
			idx <= 3'b011;
			size <= 3'b000;
			player_num <= 3'b000;
			is_guest <= 1'b0;
			fetched_IDs <= 0;
			input_ID <= 0;
			difficulty <= 4'b0000;
			Reconfig <= 1'b0;
			enable <= 1'b0;
		end
		default begin
			State <= Wait;
		end
		endcase
	end
    end
endmodule