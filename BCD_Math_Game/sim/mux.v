module mux(clk, reset, in_1, in_2, out, selector);
    input [6:0] in_1, in_2;
    output reg [6:0] out;
    input clk, reset, selector;

    initial begin
	out = 7'b1111111;
    end

    always@(posedge clk) begin
	if(reset == 1'b0) begin
            out = 7'b1111111;
	end
	else if(selector == 1'b0) begin
	    out = in_1;
	end
	else begin
	    out = in_2;
	end
    end
endmodule