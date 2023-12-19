module OneMilliSecLFSR(clk, reset, enable, timeout);
  input clk, reset, enable;
  output reg timeout;

  reg [15:0] LFSR = 16'b0000000000000000;

  always @(posedge clk) begin
    if(reset == 1'b0) begin
	timeout <= 1'b0;
    end
    else begin
        timeout <= 1'b0;
	if(enable == 1'b1) begin
            LFSR[0] <= ~LFSR[1] ^ LFSR[2] ^ LFSR[4] ^ LFSR[15];
            LFSR[15:1] <= LFSR[14:0];
        end
     end
    if(LFSR == 16'b0111101001100011) begin//long:16'b0111101001100011 short:16'b0000110110010011
	timeout <= 1'b1;
        LFSR <= 16'b0000000000000000;
    end
    end
endmodule
