//ECE6370
//Author: Jay Choe
//Module name: CountToTen
//receive signal from OneHundMiliSecMoudle and count ten times
//and generate output signal every second that is fed into digit timers.
module CountToTen(
    input one_hund_mili_sec_in,
    input clk,
    input reset,
    output reg one_sec_out
);

    //reg[1:0] count;
    reg[3:0] count;
    always@(posedge clk) begin
        if(reset == 1'b0) begin
	    count = 0;
	    one_sec_out = 0;
        end
	if(one_sec_out == 1'b1) one_sec_out = 1'b0; 
        if(one_hund_mili_sec_in == 1'b1)
	    count = count + 1;
        if(count >= 4'b0010) begin //4'b1010 //2'b10
	    one_sec_out = 1'b1;
	    count = 0;
	end
    end
endmodule