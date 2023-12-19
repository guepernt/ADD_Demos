//ECE 6370
//David Zhang, 2213233
//Authentication Testbench

//This module defines the testbench for the Authentication module. Specifically, it tests whether the new split Authentication
//module of the Access Controller can interface with the ROM/RAM correctly when the specific signals are given. It reads the
//data bits from the ROM/RAM and compares it to the player inputs to see if they are correct, after which point it will log in
//the player or not. 
`timescale 1 ns/ 100 ps
module tb_Authentication();
	reg clk, rst, passButton, passChange, logout_s;
	reg [3:0] passIn;
	wire loggedIn, loggedOut, enable, RAMRW;
	wire [4:0] addressROM, addressRAM;
	wire [3:0] dataBusROM, dataRAM_out, dataRAM_in;

	ROM_PSWD DUT_ROM(addressROM, clk, dataBusROM);
	Authentication DUT_Authentication(passIn, passButton, loggedIn, loggedOut, addressROM, dataBusROM, enable, passChange,
		       rst, clk, logout_s, RAMRW, addressRAM, dataRAM_out, dataRAM_in);
	RAM_PSWD DUT_RAM(addressRAM, clk, dataRAM_out, RAMRW, dataRAM_in);
	always
		begin	
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end 
	initial
	begin
		rst = 1'b1;
		passButton = 1'b0;
		passChange = 1'b0;
		logout_s = 1'b0;
		passIn = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);  //Arbitrary amount
		#5 rst = 1'b0; 		//All systems go
		@(posedge clk); 
		#5 rst = 1'b1; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);  
		#5 passIn = 3; passButton = 1'b1; 			//Entry of first digit
		@(posedge clk); 
		#5 passButton = 1'b0;					//Modeling shaped signal
		@(posedge clk); 
		#5 passIn = 2; passButton = 1'b1;			//Try pressing button early, shouldn't register
		@(posedge clk); 
		#5 passButton = 1'b0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); //Wait to see if state hangs (it should)
		#5 passButton = 1'b1; @(posedge clk);  #5 passButton = 1'b0; 	//Now enter at correct time after
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 3; passButton = 1'b1; @(posedge clk);  #5 passButton = 1'b0; //Entry of 3rd digit
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 3; passButton = 1'b1; @(posedge clk);  #5 passButton = 1'b0; //Entry of 4th digit
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 		 //Should be in enable state.	
		#5 passChange = 1; @(posedge clk); #5 passChange = 0; 		//ARAM time
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 4'b1111; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 4'b1110; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 4'b1101; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 4'b1100; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;		//Set password
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); #5 logout_s = 1; @(posedge clk); #5 logout_s = 0; //Log Out
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); 
		#5 passIn = 4'b1111; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		#5 passIn = 4'b1110; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		#5 passIn = 4'b1101; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;
		@(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		#5 passIn = 4'b1100; @(posedge clk); #5 passButton = 1; @(posedge clk); #5 passButton = 0;		//Set password
		
	end
endmodule
