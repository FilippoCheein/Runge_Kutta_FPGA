`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2021 03:24:19 PM
// Design Name: 
// Module Name: rca_nb
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

//
//
// Instantation
// 
//  rca_nb( .a(), .b(), .cin(), .sum(), .co());
//

module rca_nb(
    input signed [n-1:0] a,
    input signed [n-1:0] b,
    input [n-1:0] cin,
    output reg signed [n-1:0] sum,
    output reg co
    );
	
    parameter n = 32;
    
    always @(a,b,cin)
    begin
       {co,sum} = a + b + cin;    
    end
    
endmodule
