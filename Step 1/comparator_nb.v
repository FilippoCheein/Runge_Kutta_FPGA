`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 03:25:14 PM
// Design Name: 
// Module Name: comparator_nb
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


module comparator_nb(A, B, EQ, LT, GT);

 input [n-1:0] A, B;
 output reg EQ, LT, GT;

 parameter n = 32;

    always@(A, B)
    begin
        if(A > B)
            begin
                EQ = 0;
                LT = 0;
                GT = 1;
            end
         else if (A < B)
            begin
                EQ = 0;
                LT = 1;
                GT = 0;
            end
         else
            begin
                EQ = 1;
                LT = 0;
                GT = 0;
            end
    end
    
endmodule
