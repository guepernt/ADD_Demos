module SmartAirCon (enable, tempHigh, personPresent, turnOn);
	input enable, tempHigh, personPresent;
	output turnOn;
	reg turnOn;

	always @(enable, tempHigh, personPresent) 
		begin
			turnOn = enable & (tempHigh | personPresent);
		end
endmodule
