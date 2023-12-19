//ECE 6370
//David Zhang, 2213233
//Lab 4 Module

//This module defines all the modules and connections that go inside of Lab 4.
//It is functionally identical to Lab 3 except for the instantiations of 
//the ROM and RAM that are needed for some of the bonus features. 
module Lab4_ZHANG_David(P1INPUT, P2INPUT, P1DISPLAY, P2DISPLAY, TENSDISPLAY, ONESDISPLAY, SUMDISPLAY, LED_C, LED_W, LED_LI, LED_LO,
			P1BUTTON, P2BUTTON, PASSBUTTON, RST, CLK, SCORETENS);

	input [3:0] P1INPUT, P2INPUT;
	output [6:0] P1DISPLAY, P2DISPLAY, TENSDISPLAY, ONESDISPLAY, SUMDISPLAY, SCORETENS;
	output LED_C, LED_W, LED_LI, LED_LO;
	input P1BUTTON, P2BUTTON, PASSBUTTON, RST;
	input CLK;
	reg LED_C, LED_W;
	reg correctAnswer;
	reg hundreds_tensB;
	reg [6:0] dummySignal;
	reg [3:0] scoreCounterTens, scoreCounterOnes;
	reg [6:0] scoreCounterTotal;								//Minimum size for 99 correct rounds. 
	
	wire p1load_in, passButton_s, p1load_out, p2load_out;
	wire timer_enable, timer_reconfig;						//New signals from Access Controller to Digits. 
	wire ones_Timer, tens_ones, hundreds_tens;			//Signals to connect digit Timers together. 	
	wire ones_TimerB, tens_onesB;								//Borrow Signals
	wire score_enable;											
	wire correctAnswerShaped;									//Need a pulsed signal for scoring mechanic.
	wire [6:0] debugging;

	wire [3:0] p1load_N, p2load_N;
	wire [3:0] AdderOutput, tens_display, ones_display;
	wire [6:0] tensScore, onesScore, sumdisplay;
	
	wire [4:0] addressROM, addressRAM;
	wire [3:0] dataBusROM, dataRAM_out, dataRAM_in;
	wire RAMWR;

	ButtonShaper BS1(P1BUTTON, p1load_in, RST, CLK);
	//ButtonShaper BS2(P2BUTTON, p2load_in, RST, CLK);
	ButtonShaper BSP(PASSBUTTON, passButton_s, RST, CLK);
	ButtonShaper BSC(P2BUTTON, correctAnswerShaped, RST, CLK);	//BS for correct scoring mechanic.
	
	LoadRegister LR1(P1INPUT, p1load_N, CLK, RST, p1load_out);
	//LoadRegister LR2(P2INPUT, p2load_N, CLK, RST, p2load_out);	//No 2nd Load register needed, things go directly into RNG. 
	RNG_LFSR RNGesus(p2load_out, CLK, RST, p2load_N);			//Even though its not technically p2 anymore, to prevent things from breaking
																		//we keep the naming convention as it already is. 
	
	Decoder7Seg P1D(p1load_N, P1DISPLAY);				
	Decoder7Seg P2D(p2load_N, P2DISPLAY);
	Decoder7Seg PSD(AdderOutput, sumdisplay);
	Decoder7Seg scoreTensDisplay(scoreCounterTens,tensScore);	//Extra 7SD's for keeping score.
	Decoder7Seg scoreOnesDisplay(scoreCounterOnes,onesScore);

	Decoder7Seg Tens(tens_display, TENSDISPLAY);			//New Decoders for the timer digits. 
	Decoder7Seg Ones(ones_display, ONESDISPLAY);

	Adder4Bit SUM(p1load_N, p2load_N, AdderOutput);
	AccessControllerSplit MASTER(P2INPUT, passButton_s, LED_LI, LED_LO, p1load_in, P2BUTTON, p1load_out,
				p2load_out, RST, CLK, timer_reconfig, timer_enable, ones_TimerB, score_enable, addressROM, 
				dataBusROM, RAMWR, addressRAM, dataRAM_out, dataRAM_in);	//Use borrow signal of ones digit as time_out.
	
	oneSecondLFSR internalTimer(CLK, RST, timer_enable, ones_Timer);	//Instantiation of timing portion
	digitTimer OnesDigit(ones_Timer, tens_ones, tens_onesB, ones_TimerB, timer_reconfig, ones_display, CLK, RST);
	digitTimer TensDigit(tens_ones, hundreds_tens, hundreds_tensB, tens_onesB, timer_reconfig, tens_display, CLK, RST);
	
	mux_2to1 scoreTens(debugging, tensScore, score_enable, SCORETENS);
	mux_2to1 scoreOnes(sumdisplay, onesScore, score_enable, SUMDISPLAY);	//Two muxes needed for scoring feature.
	
	ROM_PSWD Romulus(addressROM, CLK, dataBusROM);
	Decoder7Seg ARAMSeg(addressRAM, debugging);								//Debugging]
	RAM_PSWD ARAM(addressRAM, CLK, dataRAM_out, RAMWR, dataRAM_in);
	
	always @(p1load_N) begin
		if (AdderOutput == 4'b1111)
			begin
				LED_C = 1'b1; LED_W = 1'b0;
			end							
		else
			begin
				LED_C = 1'b0; LED_W = 1'b1;
			end
	end
	always @(posedge CLK) begin			
		if (RST == 1'b0) begin
			hundreds_tensB <= 1'b1;			//Hundreds-Tens borrow high so tensDigit cannot borrow.
			dummySignal <= 7'b1111111;		//Whatever number to make all segments DARK.
			scoreCounterTotal <= 0;
			scoreCounterTens <= 0;
			scoreCounterOnes <= 0;
		end
		else begin
			scoreCounterTens <= scoreCounterTotal / 4'b1010;
			scoreCounterOnes <= scoreCounterTotal % 4'b1010;	//Math to make sure it counts the 10's and 1's digit.
			if (correctAnswerShaped == 1'b1) begin
				if (AdderOutput == 4'b1111) begin					//Increments on the rng button after a correct answer. 
					scoreCounterTotal <= scoreCounterTotal + 1;
				end
			end
			else if (timer_reconfig == 1'b1) begin					//This signal to wipe score as it indicates a new game starting. 
				scoreCounterTotal <= 0;
			end
		end
	end
endmodule
