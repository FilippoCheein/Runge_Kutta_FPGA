`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2021 03:44:58 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier( A, B, mult);

    parameter n = 16;
    input [n-1:0] A, B;
    output reg [n-1:0] mult;
    
    
        always @(A, B)
        begin
        
        mult = A*B;
        
        end

endmodule
