`timescale 1 ns/100 ps; 
module tb_SmartAirCon ();
	
	reg enable_s, tempHigh_s, personPresent_s;
	wire turnOn_s;

	SmartAirCon DUT_SmartAirCon (enable_s, tempHigh_s, personPresent_s, turnOn_s);
	
	initial 
		begin	
		enable_s = 0; tempHigh_s = 0; personPresent_s = 0;
		#10 enable_s = 0; tempHigh_s = 0; personPresent_s = 1;
		#10 enable_s = 0; tempHigh_s = 1; personPresent_s = 0;
		#10 enable_s = 0; tempHigh_s = 1; personPresent_s = 1;
		#10 enable_s = 1; tempHigh_s = 0; personPresent_s = 0;
		#10 enable_s = 1; tempHigh_s = 0; personPresent_s = 1;
		#10 enable_s = 1; tempHigh_s = 1; personPresent_s = 0;
		#10 enable_s = 1; tempHigh_s = 1; personPresent_s = 1;
		end


endmodule