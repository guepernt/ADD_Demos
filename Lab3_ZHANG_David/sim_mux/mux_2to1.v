//ECE6370
//David Zhang, 2213233
//Multiplexer 2 to 1

//This module defines the mux needed for implementing the bonus feature of lab 3. It takes in two 7-bit
//inputs and a 1-bit select to output a 7-bit signal. The inputs and outputs are designed to be matching
//signals of the 7-segment decoders, and thus do not represent their literal binary value. 

module mux_2to1( input [6:0] a,                 // 7-bit input called a  
                       input [6:0] b,                 // 7-bit input called b  
                       input sel,               // input sel used to select between a,b
                       output reg [6:0] out);         // 7-bit output based on input sel  
  
   // This always block gets executed whenever a/b/sel changes value  
   // When it happens, output is assigned to either a/b
   always @ (a,b,sel) begin  
      case (sel)  
         1'b0 : out <= a;  //sel 0 choose A
         1'b1 : out <= b;  //sel 1 choose B
 
      endcase  
   end  
endmodule  
