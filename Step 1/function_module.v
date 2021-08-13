`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Filippo Cheein
// 
// Create Date: 07/21/2021 12:16:42 PM
//
// Design Name: H Generator, Function module, Y generator
//
// Module Name: function_module
// Project Name: RK4
// Target Devices: Basys 3 Board
// Description: 
// 


// function module
//
// Base function
// dy_dx = (x - y)/2 
//
// RK4 function
// DY_DX = (X_IN + H_IN - Y_IN - K_IN)/2
//
// Instantiation
// function_module( .X_IN(), .Y_IN(), .H_IN(), .K_IN(), .clk(), .DY_DX() );
//
module function_module(X_IN, Y_IN, H_IN, K_IN, clk, K_sign, DY_DX);
 
 parameter n = 32;
 
 input clk;
 input signed [n-1:0] X_IN, Y_IN, H_IN, K_IN;
 output signed [n-1:0] DY_DX;
 output K_sign;
 wire SIGN_FLAG;
 wire [n-1:0] sum_x_h, sum_y_k, sub_out;
  
  // sum_x_h = X_IN + H_IN
  rca_nb adder_1 ( .a(X_IN), .b(H_IN), .cin(0), .sum(sum_x_h), .co());
  
  // sum_y_k = Y_IN + K_IN
  rca_nb adder_2 ( .a(Y_IN), .b(K_IN), .cin(0), .sum(sum_y_k), .co());
  
  // sub_out = X_IN + H_IN - Y_IN - K_IN;
  subtractor_nb sub( .A(sum_x_h), .B(sum_y_k), .SUB(sub_out), .sign_flag(SIGN_FLAG), .Co() );
  
  assign K_sign = SIGN_FLAG;
  
  // DY_DX = (X_IN + H_IN - Y_IN - K_IN)/2;
  signed_shifter div_by_2( .data_in(sub_out), .dbit(SIGN_FLAG), .sel(1'b1), .data_out(DY_DX));
  
endmodule
