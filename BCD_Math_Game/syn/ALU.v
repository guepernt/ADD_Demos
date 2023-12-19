//Course number: ECE6370
//Author: Vishal Reddy, PSID: 7936
//module description: Arithemetic Logic Unite(ALU) that computes user input and generate corresponding
//results
//Comments:
module ALU(clk, reset, RNG_In_D1000, RNG_In_D100, RNG_In_D10, RNG_In_D1, Game_Start, Load_Input, Timeout, Player_Input, 
            Score, Score_Req, LEDs);

    input clk, reset;
    input[3:0] RNG_In_D1000, RNG_In_D100, RNG_In_D10, RNG_In_D1;
    input[3:0] Player_Input;
    input Timeout, Game_Start, Load_Input;

    output[6:0] Score;
    output Score_Req;
    output[3:0] LEDs;

    reg[6:0] Score, Cnt;
    reg[3:0] LEDs;
    reg Score_Req;
    reg[3:0] Result;
    reg[2:0] Counter;
    parameter INIT=0, PLAY=1, SCORE=2, CHECKSCORE=3;
    reg[2:0] State;

    reg[15:0] RNG_In;


    always@(posedge clk)
    begin
        if(reset==0)
        begin
            Score<=7'b0000000;
            Cnt<=7'b0000000;
            Counter<=3'b000;
            Score_Req<=1'b0;
            LEDs<=4'b0000;
            Result<=4'b0000;
            State<=INIT;
        end
        else
        begin
	    RNG_In = (RNG_In_D1000[3]*8 + RNG_In_D1000[2]*4 + RNG_In_D1000[1]*2 + RNG_In_D1000[0]*1)*1000 + 
		(RNG_In_D100[3]*8 + RNG_In_D100[2]*4 + RNG_In_D100[1]*2 + RNG_In_D100[0]*1)*100 + 
		(RNG_In_D10[3]*8 + RNG_In_D10[2]*4 + RNG_In_D10[1]*2 + RNG_In_D10[0]*1)*10 + 
		RNG_In_D1[3]*8 + RNG_In_D1[2]*4 + RNG_In_D1[1]*2 + RNG_In_D1[0]*1;
            case(State)
            INIT: begin
                      Score<=7'b0000000;
                      Cnt<=7'b0000000;
                      Counter<=3'b000;
                      Score_Req<=1'b0;
                      LEDs<=4'b0000;
                      Result<=4'b0000;
                      if(Game_Start==1'b1) begin State<=PLAY; end
                      else begin State<=INIT; end
                  end
            PLAY: begin
                      if(RNG_In[3:0]%2==0) begin Result[0]<=1'b1; end
                      else begin Result[0]<=1'b0; end
                      if((RNG_In[15:12]+RNG_In[11:8]+RNG_In[7:4]+RNG_In[3:0])%3==0) begin Result[1]<=1'b1; end
                      else begin Result[1]<=1'b0; end
                      if((RNG_In[15:12]*1000+RNG_In[11:8]*100+RNG_In[7:4]*10+RNG_In[3:0])%7==0) begin Result[2]<=1'b1; end
                      else begin Result[2]<=1'b0; end
                      if((RNG_In[15:12]-RNG_In[11:8]+RNG_In[7:4]-RNG_In[3:0])%11==0) begin Result[3]<=1'b1; end
                      else begin Result[3]<=1'b0; end

                      if(Load_Input==1'b1) begin

                          State<=SCORE;
                      end
                      
		      //Time is over
                      else if(Timeout==1'b0) begin 
                          Score_Req <= 1'b1;
                          State<=CHECKSCORE;
                      end
                      else begin State<=PLAY; end
                  end
	    SCORE: begin
		 LEDs <= Result;
	         if(Player_Input == Result) begin
                    Score<=Score+1;
                      if(Timeout==1'b1) begin 
                          State<=PLAY;
                      end
                      else begin
                          Score_Req <= 1'b1;
                          State<=CHECKSCORE;
		      end
                 end
            else begin
                State <= PLAY;
            end
	    end
            CHECKSCORE: begin
                Score_Req <= 1'b0;
                if(Load_Input==1'b1) begin
                    State <= INIT;
                end
            end
            default: begin
                         Score<=7'b0000000;
                         Cnt<=7'b0000000;
                         Counter<=3'b000;
                         Score_Req<=1'b0;
                         LEDs<=4'b0000;
                         Result<=4'b0000;
                         State<=INIT;
                     end
            endcase
        end
    end
endmodule