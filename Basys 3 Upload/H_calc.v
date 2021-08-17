`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 08/13/2021 11:33:47 AM
// Design Name: Runge Gutta Algorithm for FPGA
// Module Name: H_calc
// Project Name: RK4_FPGA
// Target Devices: Basys 3 Board
// 
// Description: 
// 
// Dependencies: 
// This module calculates the H value for the system. 
//
// Revision:
// 
// 
//////////////////////////////////////////////////////////////////////////////////


// Module to calculate H
module H_calc(X_o, C, N, H_sign, H);
    
 parameter n = 32;
    
 input [n-1:0] C, X_o, N;
 wire [n-1:0] C_X_sub;
 wire SIGN_FLAG;
 output H_sign;
 output [n-1:0] H;   
    
     // C_X_sub = C - X_o
     subtractor_nb H_sub( .A(C), .B(X_o), .SUB(C_X_sub), .sign_flag(SIGN_FLAG), .Co() );
     
     assign H_sign = SIGN_FLAG;
     
  // H = (C - X_o)*1/N
     fixed_multi H_out (.num1(C_X_sub), .num2(N), .num1_sign(SIGN_FLAG), .num2_sign(1'b0), .result(H), .overflow(), .precisionLost(), .result_full() );
   
endmodule
