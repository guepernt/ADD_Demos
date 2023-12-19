//ECE6370
//Author: Jay Choe
//Module name: OneSecondTimer
//This is the module included in the TwoBitsTimer module
//which generate signal every second and deliver the signal
//to the lowest level digit timer.
module OneSecondTimer(
    input en,
    input clk,
    input reset,
    output wire one_sec_out
);
    
    wire one_hund_mili_sec;
    OneHundMiliSecTimer OneHundMiliSecTimer_inst(en, clk, reset, one_hund_mili_sec);
    CountToTen CountToTen_inst(one_hund_mili_sec, clk, reset, one_sec_out);
    

endmodule
