`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2021 10:31:40 AM
// Design Name: 
// Module Name: mux_4t1_nb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


 module mux_4t1_nb(SEL, D0, D1, D2, D3, D_OUT); 
       input  [1:0] SEL; 
       input signed [n-1:0] D0, D1, D2, D3; 
       output reg signed [n-1:0] D_OUT;  
       
       parameter n = 4; 
        
       always @(SEL, D0, D1, D2, D3)
       begin 
          if      (SEL == 0)  D_OUT = D0;
          else if (SEL == 1)  D_OUT = D1; 
          else if (SEL == 2)  D_OUT = D2; 
          else if (SEL == 3)  D_OUT = D3; 
          else                D_OUT = 4'b0000; 
       end
                
endmodule

