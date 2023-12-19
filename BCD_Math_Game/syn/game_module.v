module game_module(clk, reset, RNG_In_D1000, RNG_In_D100, RNG_In_D10, RNG_In_D1, Logged_In, Game_Start, Load_Input, Timeout, playerID, Player_Input,
                    LEDs, D10, D1,Personal_Winner, Is_Valid, Global_Winner, LEDs);

input clk, reset;
input Logged_In, Game_Start, Load_Input, Timeout;
input [4:0] playerID;
input [3:0] Player_Input;
input [3:0] RNG_In_D1000, RNG_In_D100, RNG_In_D10, RNG_In_D1;

//Later connect to output
output [3:0] LEDs;
output [3:0] D10, D1;

wire Score_Req;
wire [6:0] Score, toRAM, fromRAM;
output Personal_Winner, Is_Valid;
output [4:0] Global_Winner;
wire [4:0]  RAMaddr;
wire WRen;

ALU ALU_Instance(clk, reset, RNG_In_D1000, RNG_In_D100, RNG_In_D10, RNG_In_D1, Game_Start, Load_Input, Timeout, Player_Input, Score, Score_Req, LEDs);

Scoring Scoring_Instance(Score_Req, playerID, Score, Personal_Winner, Global_Winner, Is_Valid, WRen, toRAM, fromRAM, RAMaddr, D10, D1, clk , reset);
RAM_Scoring RAM_Scoring_Instance(RAMaddr, clk, toRAM, WRen, fromRAM);

endmodule

