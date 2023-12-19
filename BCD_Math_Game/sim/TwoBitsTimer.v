module TwoBitsTimer(clk,reset,timer_en,timer_reconfig,tens_digit,ones_digit,time_out, difficulty);
    input clk;
    input reset;
    input timer_en;
    input timer_reconfig;
    input [3:0] difficulty;
    output [3:0] tens_digit;
    output [3:0] ones_digit;
    output wire time_out;

    wire tick;
    //wire res_from_up, req_from_bottom;
    wire req_from_one_to_ten, res_from_ten_to_one;
    wire req_from_bottom;
    //wire res_to_bottom;
    wire req_to_up;

    //DigitTimer(clk, reset, tick, reconfig, res_from_up, req_from_bottom, digit, req_to_up, res_to_bottom);

    OneSecondTimer OneSecondTimer_Inst(timer_en, clk, reset, tick);
    DigitTimer TensDigit(clk, reset, 1'b0, timer_reconfig, 1'b0, req_from_one_to_ten, tens_digit, req_to_up, res_from_ten_to_one, difficulty, 1'b1);
    DigitTimer OnesDigit(clk, reset, tick, timer_reconfig, res_from_ten_to_one, req_from_bottom, ones_digit, req_from_one_to_ten, time_out, difficulty, 1'b0);

    //DigitTimer TensDigit(clk, reset, 1'b0, timer_reconfig, loop_wire_from_ten_to_one, req_from_one_to_ten, tens_digit, loop_wire_from_one_to_ten, time_out, res_from_ten_to_one);
    //DigitTimer OnesDigit(clk, reset, tick, timer_reconfig, res_from_ten_to_one, loop_wire_from_one_to_ten, ones_digit, req_from_one_to_ten, time_out, loop_wire_from_ten_to_one);

endmodule
