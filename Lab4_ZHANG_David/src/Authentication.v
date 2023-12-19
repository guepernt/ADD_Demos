//ECE 6370
//David Zhang, 2213233
//Authentication Module

//This module defines the Authentication half of the Access Controller. It takes in a shaped signal from the Password button
//along with a 4-bit binary input from the slide switches. It reads these inputs and determines whether the correct password
//defined in the ROM/RAM has been input, after which case it sets enable high, signalling to the GameController half to start
//normal operation of the Game. 

module Authentication(passIn, passButton, loggedIn, loggedOut, addressROM, dataBusROM, enable, passChange, rst, clk,
		      logout_s, RAMWR, addressRAM, dataRAM_out, dataRAM_in);
	input passButton, rst, clk, passChange, logout_s;			//New signals from GameController
	input [3:0] passIn, dataBusROM, dataRAM_in;				//New input from the ROM,bus signal.
	output loggedIn, loggedOut, enable, RAMWR;
	output [4:0] addressROM, addressRAM;					//New 2-bit output to ROM
	output [3:0] dataRAM_out; 						//4-bit data out to RAM

	parameter DIGIT = 0, VERIFY = 4, OPERATIONAL = 5;	//Importantly these states are needed for new operation.
	reg passwordRight, loggedIn, loggedOut, enable;
	reg[3:0] State;
	reg[2:0] digits_place;					//Which digit am I on? 
	reg[1:0] WaitingForROM;							//Timer to stay in states until ROM/RAM done reading. 
	reg switchToRAM;							//New flag for bonus feature
	reg[4:0] addressROM, addressRAM;		//Address bits for ROM/RAM, minimum 5 bits
	reg[3:0] dataROM; 							//Internal storage for whatever comes from dataBusROM
	reg RAMWR; 								//Write enable signal for RAM
	reg[3:0] dataRAM_out; 							//Outgoing data bits to RAM
	reg[3:0] dataRAM_storage;						//Storage for ingoing data bits of RAM
	reg[1:0] RAMWait1, RAMWait2;

	always@(posedge clk) begin
		if (rst == 1'b0) begin						//Reset of all signals.
			State <= DIGIT;
			passwordRight <= 1'b1;
			loggedIn <= 1'b0;
			loggedOut <=1'b1;
			WaitingForROM <= 1'b0;
			enable <= 1'b0;
			switchToRAM <= 1'b0;					 //Only gets wiped at reset, not logout.
			addressROM <= 0;					
			dataRAM_out <= 0;
			addressRAM <= 0;
			digits_place <= 0;
			RAMWR <= 0;								//Set to always be reading from RAM	
			dataRAM_storage <= 0;
			RAMWait1 <= 0;
			RAMWait2 <= 0;
			end
		else 
			case(State) 
				DIGIT: begin					//Setting all signals to correct baseline		 
					loggedIn <= 1'b0;
					loggedOut <=1'b1;
					enable <= 1'b0;
					if (digits_place != 4) begin		//If we are on the "5th" digit, dont even bother just go to end.
						if (WaitingForROM != 2'b11) begin	//Ensures that we don't have looping behavior
							WaitingForROM <= WaitingForROM + 1'b1;
						end
						if (WaitingForROM == 2'b11) begin	//Wait at least 3 clock cycles for number from ROM/RAM to come back
							dataROM <= dataBusROM;		//Store whatever was retrieved onto internal store
							if (switchToRAM == 1'b0) begin	//Flag has not been triggered, assume ROM
								if (passButton == 1'b1)begin //Operation should ONLY proceed whenever button depressed.
									if (passIn == dataROM)begin	//Checks player switches vs. whatever came from ROM
										State <= DIGIT;
										WaitingForROM <= 1'b0;	//Reset the wait time each transition.
										addressROM <= addressROM + 1'b1;	//Move to next ROM address.
										digits_place <= digits_place + 1;
									end
									else begin
										passwordRight <= 1'b0;	//Mark as wrong if it was wrong (duh)
										State <= DIGIT;
										WaitingForROM <= 1'b0;
										addressROM <= addressROM + 1'b1;
										digits_place <= digits_place + 1;
									end
								end
							end
							else begin			//FLag has been triggered, do all subsequent stuff in RAM
									if (RAMWR == 1'b1) begin		//Beginning of password overwrite
										//dataRAM_storage <= passIn;
										if (passButton == 1'b1) begin
											dataRAM_out <= passIn;	//Pass the inputs to the RAM
											addressRAM <= addressRAM + 1; 	//Advance to next address
											digits_place <= digits_place + 1; //Advance to next digit
											WaitingForROM <= 1'b0; 		//Reset wait timer
											State <= DIGIT;
										end
									end
									else begin							//Subsequent READ cycles, identical to ROM
										dataRAM_storage <= dataRAM_in;
										//if (RAMWait1 != 2'b11) begin
											//RAMWait1 <= RAMWait1 + 1;
											if (RAMWait2 != 1'b1) begin
												addressRAM <= addressRAM +1;
												RAMWait2 <= RAMWait2 + 1;
												WaitingForROM <= 0;
											end
										//end
										else begin 
											if (passButton == 1'b1)begin 
												if (passIn == dataRAM_storage) begin	//Checks player switches vs. whatever came from RAM
													State <= DIGIT;
													WaitingForROM <= 1'b0;	
													addressRAM <= addressRAM + 1'b1;	
													digits_place <= digits_place + 1;
													//WaitingForRAM <= 0;
												end
												else begin
													passwordRight <= 1'b0;	
													State <= DIGIT;
													WaitingForROM <= 1'b0;
													addressRAM <= addressRAM + 1'b1;
													digits_place <= digits_place + 1;
													//WaitingForRAM <= 0;
												end
											end
										end
									end
							end
						end		
					end
					else begin
						State <= VERIFY;	//Move to verify on the last digit. 
					end	
				end

				VERIFY: begin
					digits_place <= 0;
					RAMWR <= 0;
					if (passwordRight == 1'b1)begin	//Verification check. All numbers should have
						State <= OPERATIONAL;	//been entered correctly up to this stage.
						addressROM <= 0;
						addressRAM <= 0;
						RAMWait1 <= 0;
						RAMWait2 <= 0;
					end
					else begin
						State <= DIGIT;
						addressROM <= 0;	//Arbitrary where to put, but reset address here
						addressRAM <= 0;
						passwordRight <= 1'b1;	//Set pass to right and return to start.
						RAMWait1 <= 0;
						RAMWait2 <= 0;
					end
				end
				OPERATIONAL: begin
					loggedIn <= 1'b1;
					loggedOut <= 1'b0;		//Arbitrary where to put, but at this point should be logged in
					enable <= 1'b1;			//Keep enable high for correct operation
					if (passChange == 1'b1) begin
						State <= DIGIT;
						switchToRAM <= 1'b1; 	//Switch to RAM since player wanted to password change.
						enable <= 1'b0; 	//In either of these cases, should lockout player control
						RAMWR <= 1'b1;		//write enable, so 1
					end
					if (logout_s == 1'b1) begin
						State <= DIGIT;
						enable <= 1'b0;
					end
				end

				default: begin
					State <= DIGIT;
					passwordRight <= 1'b1;
					loggedIn <= 1'b0;
					loggedOut <=1'b1;
					WaitingForROM <= 1'b0;
					enable <= 1'b0;
					addressROM <= 0;
					dataRAM_out <= 0;
					addressRAM <= 0;
					digits_place <= 0;
					RAMWR <= 0;
				end
			endcase
		end
endmodule
