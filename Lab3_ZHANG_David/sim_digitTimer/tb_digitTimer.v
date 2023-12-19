//ECE 6370 
//David Zhang, 2213233
//Digit Timer Testbench.

//This module defines the testbench for the Digit Timer modules. It instantiates an arbitrary, greater than 1 
//number of Digit Timers and links them together. It then feeds the a single pulse signal created from the modified 1secTimer into 
//the least significant digit after loading all timers with 9. 
`timescale 1 ns/100 ps
module tb_digitTimer();
	reg clk, rst, noBorrow_1100, reconfig, enable;
	wire [3:0] onesDigit, tensDigit, hundredsDigit;
	wire decrement_11, decrement_110, decrement_1100, noBorrow_11, noBorrow_110, noBorrow_1, second_out;

	digitTimer ones(second_out, decrement_11, noBorrow_11, noBorrow_1, reconfig, onesDigit, clk, rst);
	digitTimer tens(decrement_11, decrement_110, noBorrow_110, noBorrow_11, reconfig, tensDigit, clk, rst);
	digitTimer hundreds(decrement_110, decrement_1100, noBorrow_1100, noBorrow_110, reconfig, hundredsDigit, clk, rst);
	oneSecondTimer oneSec(clk, rst, enable, second_out);
	
	//Instantiation of 3 timer modules for each base 10 digit. Each is linked to the other through wires. The naming convention of the 
	//wires shows which digits are linked by 1's, i.e. 110 is the wire connecting hundreds to tens. 

	//oneSecondTimer here is the modified version that counts 24 clock cycles per pulsed output. 
	
	always
		begin	
			clk = 1'b0;
			#10;
			clk = 1'b1;
			#10;
		end 
	initial
	begin
		enable = 1'b0;
		rst = 1'b1;
		noBorrow_1100 = 1'b1;		//Signals all start at 0, noBorrow always stays at 1 to ensure that hundreds does not borrow.
		reconfig = 1'b0;
		@(posedge clk); @(posedge clk); @(posedge clk);
		#5 rst = 1'b0;
		@(posedge clk);
		#5 rst = 1'b1;
		reconfig = 1'b1;		//Reset signal and Reconfig to load Timers. 
		@(posedge clk);
		reconfig = 1'b0;
		@(posedge clk);
		@(posedge clk);
		enable = 1'b1;
		@(posedge clk);
		enable = 1'b0;
		//Arbitrary amount of clock cycles, should decrement correctly from 999 one at a time per pulsed input. 
	end
endmodule

