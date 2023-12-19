//ECE6370
//Author: Jay Choe
//Module name: CountToHundred
//receive signal from OneMiliSecMoudle and count hundreds times
//so that the output is 100 ms.
module CountToHundred(
    input one_mili_sec_in,
    input clk,
    input reset,
    output reg one_hund_mili_sec_out
);

    reg[6:0] count;
    //reg[1:0] count;
    always@(posedge clk) begin
        if(reset == 1'b0) begin
	    count = 0;
	    one_hund_mili_sec_out = 0;
        end
	if(one_hund_mili_sec_out == 1'b1) one_hund_mili_sec_out = 1'b0;
        if(one_mili_sec_in == 1'b1)
	    count = count + 1;
        if(count >= 7'b1100100) begin //original: 7'b1100100 //2'b11
	    one_hund_mili_sec_out = 1'b1;
	    count = 0;
	end
    end
endmodule
