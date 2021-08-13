`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/24/2021 01:04:14 PM
// Design Name: 
// Module Name: subtractor
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
// Instantiation
//
// subtractor_nb( .A(), .B(), .SUB(), .Co() );
//
module subtractor_nb(A, B, SUB, sign_flag, Co);

    parameter n = 32;

    input signed [n-1:0] A, B;
    output signed [n-1:0] SUB;
    output sign_flag;
    output Co;
    
    rca_nb subtr ( .a(A), .b(~B), .cin(32'b0000000000000000_0000000000000001), .sum(SUB), .co(Co));
    
    comparator_nb neg (.A(A), .B(B), .EQ(), .LT(sign_flag), .GT() );
    
endmodule
