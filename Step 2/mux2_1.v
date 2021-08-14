`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 03:22:36 PM
// Design Name: 
// Module Name: mux2_1
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


// MUX 2to1
module mux2_1(IN_0, IN_1, SEL, OUT);

input SEL;
input [n-1:0] IN_0, IN_1;
output reg [n-1:0] OUT;

parameter n = 32;

    always@(IN_0, IN_1) 
      begin
        case(SEL)
        1'b0: OUT = IN_0;
        1'b1: OUT = IN_1;
        default : OUT = IN_0;
        endcase
      end  
  
  endmodule
 
