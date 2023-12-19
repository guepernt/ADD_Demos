//ECE 6370
//Author: David Zhang, 3233
//Access Controller Module, Lab 4

//This module defines the modified access controller for the mental binary game, which replaces the logout feature and button
//with a button to load 99 seconds into the timer and start the subsequent game. After the timer reaches 0, all features are 
//locked out until the button is pushed again to add 99 seconds, then pushed again to start a new round. In addition, the timer
//and authentication functions have been split into two separate modules named GameController and Authentication. 

module AccessControllerSplit(passIn, passButton, loggedIn, loggedOut, p1loadIn, p2loadIn, p1loadOut, p2loadOut, 
			     rst, clk, timer_reconfig, timer_enable, time_out, score_enable, addressROM, dataBusROM,
			     );
	input [3:0] passIn, dataBusROM;
	input passButton, p1loadIn, p2loadIn, rst, clk;
	input time_out;
	output timer_reconfig, timer_enable, score_enable;
	output loggedIn, loggedOut, p1loadOut, p2loadOut;
	output [4:0] addressROM;
	reg loggedIn, loggedOut, p1loadOut, p2loadOut, timer_reconfig, timer_enable, score_enable;

	wire enable, logout_s, passReset;
	wire RAMRW, addressRAM, dataRAM_out, dataRAM_in;	//To be sized and changed to outputs later

	GameController MASTER(enable, passButton, p1loadIn, p2loadIn, p1loadOut, p2loadOut, rst, clk, timer_reconfig,
			      timer_enable, time_out, score_enable, logout_s, passReset);
	Authentication MASUTAH(passIn, passButton, loggedIn, loggedOut, addressROM, dataBusROM, enable, passReset,
			       rst, clk, logout_s, RAMRW, addressRAM, dataRAM_out, dataRAM_in); 
	
endmodule

