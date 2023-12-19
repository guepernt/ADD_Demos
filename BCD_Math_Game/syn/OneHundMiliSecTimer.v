//ECE6370
//Author: Jay Choe
//Module name: OneHundMiliSecTimer
//This is the module integrating sub-modules responsible for
//generating 100ms pulse signals.
module OneHundMiliSecTimer(
    input en,
    input clk,
    input reset,
    output wire one_hund_mili_sec_out
);
    //reg[15:0] count;
    wire count;
    OneMilliSecLFSR OneMilliSecLFSR_inst(clk, reset, en, count);
    CountToHundred CountToHundred_Inst(count, clk, reset, one_hund_mili_sec_out);

endmodule
        
