`timescale 1 ns / 100 ps
module testbench_BCD_Math_Game();
    reg clk, reset;  
    reg[3:0] input_data, Player_input;
    reg RNG_Gen_In, Load_P_Input, load;
    reg [3:0] Player_Input;

    wire logged_in, logged_out, is_guest, RNG_Gen_Out, Load_P_Out;
    wire [6:0] tens_digit, ones_digit, D100_Disp, D10_Disp, D1_Disp,  Diff_And_Hundred_Disp;
    wire [3:0] LEDs;

    reg [6:0] i;

    always
	begin
	    clk = 1'b0;
	    #10;
	    clk = 1'b1;
	    #10;
	end

	BCD_Math_Game DUT_BCD_Math_Game(clk, reset, RNG_Gen_In, Load_P_Input, load, input_data, Player_input, logged_in, logged_out, tens_digit, ones_digit, is_guest, D100_Disp, D10_Disp, D1_Disp,  Diff_And_Hundred_Disp, LEDs);

	initial
	    begin
		reset = 1'b1;
		input_data = 4'b0000;
		RNG_Gen_In = 1'b1;
		Load_P_Input = 1'b1;
		Player_Input = 4'b0000;
		load = 1'b1;
		@(posedge clk);
	        @(posedge clk);
	        #5 reset = 1'b0;
	        @(posedge clk);
	        @(posedge clk);
	        #5 reset = 1'b1;
			for(i=0; i<30;i=i+1) begin
	            @(posedge clk);
			end
			//ID input
			#5 input_data = 9;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 9;
	        @(posedge clk);
	        @(posedge clk);
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 9;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 9;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<80;i=i+1) begin
	            @(posedge clk);
			end
			//password verification start
			#5 input_data = 0;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 1;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 2;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 3;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 4;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
			#5 input_data = 5;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			//#5 load = 1'b0;
	        @(posedge clk);
			//#5 load = 1'b1;
			for(i=0; i<20;i=i+1) begin
	            @(posedge clk);
			end
			//set difficulty level
			@(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			#5 Load_P_Input = 1'b0;
			@(posedge clk);
			#5 Load_P_Input = 1'b1;
			@(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
			@(posedge clk);
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<20;i=i+1) begin
	            @(posedge clk);
			end
		//Start the timer(Game Start)
			#5 load = 1'b0;
	        @(posedge clk);
			#5 load = 1'b1;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
		//Scoreing process
			#5 RNG_Gen_In= 1'b0;
	        @(posedge clk);
			#5 RNG_Gen_In = 1'b1;
			for(i=0; i<20;i=i+1) begin
	            @(posedge clk);
			end
			#5 Player_Input = 4'b0110;
			for(i=0; i<10;i=i+1) begin
	            @(posedge clk);
			end
		#5 Load_P_Input = 1'b1;
	        @(posedge clk);
	        @(posedge clk);
		#5 Load_P_Input = 1'b0;
 	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
	        @(posedge clk);
		end
endmodule
