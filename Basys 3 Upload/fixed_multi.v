`timescale 1ns / 1ps
/* ----------------------------------------------------- *
 * Title       : FixFlo Adder Multiplier Modules         *
 * Project     : Fixed Floating Point Adder Multiplier   *
 * ----------------------------------------------------- *
 * File        : adderMultiplier16.v                     *
 * Author      : Yigit Suoglu                            *
 * Last Edit   : 20/05/2021                              *
 * Revised by  : Filippo Cheein
 * Revised on  : 07/2021
 * ----------------------------------------------------- *
 * Description : Modules for multiplication *
 *               of 16 bit unsigned fixed point formated 
 *               numbers                                 *
 * Revision: revised to accomodate signed numbers        *
 *           Added two sign flags to know how to handle  *
 *                 the incoming values and the result    *
 * ----------------------------------------------------- */

/*
 *
 * Fixed Point Format:
 *   Most significant 8 bits represent integer part and Least significant 8 bits
 *   represent fraction part
 *   i.e. IIIIIIIIFFFFFFFF = IIIIIIII.FFFFFFFF
 * ----------------------------------------------------------------------------
 *
 *
 */
//fixed multi multiplies unsigned fixed numbers.
//
// instantiation
// fixed_multi test (.num1(), .num2(), .result(), .overflow(), .precisionLost(), .result_full() );
//
//  halfer
//  fixed_multi test (.num1(), .num2(16'b00000000_10000000), .result(), .overflow(), .precisionLost(), .result_full() );
//
//  doubler
//
//  fixed_multi test (.num1(), .num2(16'b00000010_00000000), .result(), .overflow(), .precisionLost(), .result_full() );
//
module fixed_multi(num1, num2, num1_sign, num2_sign, result, overflow, precisionLost, result_full);
  parameter n_half = 32;
  input signed [n_half - 1:0] num1, num2; //num1 is multiplicand and num2 is multiplier
  input num1_sign, num2_sign;
  output signed [n_half - 1:0] result;
  output signed overflow, precisionLost;
  parameter n = 64;
  reg signed [n-1:0] mid [31:0]; //shifted values
  reg signed [n-1:0] midB[7:0]; //addition of shifted values
  output signed [n-1:0] result_full; //32-bit results
  wire [n-1:0] mid_sum;
  wire result_sign;
  reg signed [n-1:0] num1_ext, num2_ext;

  //assign num1_ext = {8'd0, num1, 8'd0};
  assign precisionLost = |result_full[7:0];
  assign result = result_full[47:16]; //get rid of extra bits
  assign overflow = |result_full[31:24]; // most significant 8-bit is overflow
  assign mid_sum = midB[0] + midB[1] + midB[2] + midB[3] + midB[4] + midB[5] + midB[6] + midB[7];
  
  // to account for signs
  assign result_sign = (num1_sign ^ num2_sign);
  assign result_full = result_sign ? (~mid_sum +1) : mid_sum ;
  
  always@* //midB wires are added for readability
    begin
      midB[0] = mid[0] + mid[8] + mid[16] + mid[24];
      midB[1] = mid[1] + mid[9] + mid[17] + mid[25];
      midB[2] = mid[2] + mid[10] + mid[18] + mid[26];
      midB[3] = mid[3] + mid[11] + mid[19] + mid[27];
      midB[4] = mid[4] + mid[12] + mid[20] + mid[28];
      midB[5] = mid[5] + mid[13] + mid[21] + mid[29];
      midB[6] = mid[6] + mid[14] + mid[22] + mid[30];
      midB[7] = mid[7] + mid[15] + mid[23] + mid[31];
    end
  always@* //shift and enable control
    begin
    if (num1_sign & num2_sign) // if both numbers are negeative
        begin
         num1_ext = {16'd0, ~num1 + 1, 16'd0};
         num2_ext = ~num2 + 1;
         mid[0]  = (num1_ext >> 16) & {64{num2_ext[0]}};
         mid[1]  = (num1_ext >> 15) & {64{num2_ext[1]}};
         mid[2]  = (num1_ext >> 14) & {64{num2_ext[2]}};
         mid[3]  = (num1_ext >> 13) & {64{num2_ext[3]}};
         mid[4]  = (num1_ext >> 12) & {64{num2_ext[4]}};
         mid[5]  = (num1_ext >> 11) & {64{num2_ext[5]}};
         mid[6]  = (num1_ext >> 10) & {64{num2_ext[6]}};
         mid[7]  = (num1_ext >> 9) & {64{num2_ext[7]}};
         mid[8]  = (num1_ext >> 8) & {64{num2_ext[8]}};
         mid[9]  = (num1_ext >> 7) & {64{num2_ext[9]}};
         mid[10] = (num1_ext >> 6) & {64{num2_ext[10]}};
         mid[11] = (num1_ext >> 5) & {64{num2_ext[11]}};
         mid[12] = (num1_ext >> 4) & {64{num2_ext[12]}};
         mid[13] = (num1_ext >> 3) & {64{num2_ext[13]}};
         mid[14] = (num1_ext >> 2) & {64{num2_ext[14]}};
         mid[15] = (num1_ext >> 1) & {64{num2_ext[15]}};
         mid[16]  = num1_ext       & {64{num2_ext[16]}};
         mid[17]  = (num1_ext << 1) & {64{num2_ext[17]}};
         mid[18]  = (num1_ext << 2) & {64{num2_ext[18]}};
         mid[19]  = (num1_ext << 3) & {64{num2_ext[19]}};
         mid[20]  = (num1_ext << 4) & {64{num2_ext[20]}};
         mid[21]  = (num1_ext << 5) & {64{num2_ext[21]}};
         mid[22]  = (num1_ext << 6) & {64{num2_ext[22]}};
         mid[23]  = (num1_ext << 7) & {64{num2_ext[23]}};
         mid[24]  = (num1_ext << 8) & {64{num2_ext[24]}};
         mid[25]  = (num1_ext << 9) & {64{num2_ext[25]}};
         mid[26] =  (num1_ext << 10) & {64{num2_ext[26]}};
         mid[27] =  (num1_ext << 11) & {64{num2_ext[27]}};
         mid[28] =  (num1_ext << 12) & {64{num2_ext[28]}};
         mid[29] =  (num1_ext << 13) & {64{num2_ext[29]}};
         mid[30] =  (num1_ext << 14) & {64{num2_ext[30]}};
         mid[31] =  (num1_ext << 15) & {64{num2_ext[31]}};
        end
    else if (num1_sign) // if only num1 is negative
        begin
         num1_ext = {16'd0, ~num1+1, 16'd0};
         num2_ext = num2;
          mid[0]  = (num1_ext >> 16) & {64{num2_ext[0]}};
         mid[1]  = (num1_ext >> 15) & {64{num2_ext[1]}};
         mid[2]  = (num1_ext >> 14) & {64{num2_ext[2]}};
         mid[3]  = (num1_ext >> 13) & {64{num2_ext[3]}};
         mid[4]  = (num1_ext >> 12) & {64{num2_ext[4]}};
         mid[5]  = (num1_ext >> 11) & {64{num2_ext[5]}};
         mid[6]  = (num1_ext >> 10) & {64{num2_ext[6]}};
         mid[7]  = (num1_ext >> 9) & {64{num2_ext[7]}};
         mid[8]  = (num1_ext >> 8) & {64{num2_ext[8]}};
         mid[9]  = (num1_ext >> 7) & {64{num2_ext[9]}};
         mid[10] = (num1_ext >> 6) & {64{num2_ext[10]}};
         mid[11] = (num1_ext >> 5) & {64{num2_ext[11]}};
         mid[12] = (num1_ext >> 4) & {64{num2_ext[12]}};
         mid[13] = (num1_ext >> 3) & {64{num2_ext[13]}};
         mid[14] = (num1_ext >> 2) & {64{num2_ext[14]}};
         mid[15] = (num1_ext >> 1) & {64{num2_ext[15]}};
         mid[16]  = num1_ext       & {64{num2_ext[16]}};
         mid[17]  = (num1_ext << 1) & {64{num2_ext[17]}};
         mid[18]  = (num1_ext << 2) & {64{num2_ext[18]}};
         mid[19]  = (num1_ext << 3) & {64{num2_ext[19]}};
         mid[20]  = (num1_ext << 4) & {64{num2_ext[20]}};
         mid[21]  = (num1_ext << 5) & {64{num2_ext[21]}};
         mid[22]  = (num1_ext << 6) & {64{num2_ext[22]}};
         mid[23]  = (num1_ext << 7) & {64{num2_ext[23]}};
         mid[24]  = (num1_ext << 8) & {64{num2_ext[24]}};
         mid[25]  = (num1_ext << 9) & {64{num2_ext[25]}};
         mid[26] =  (num1_ext << 10) & {64{num2_ext[26]}};
         mid[27] =  (num1_ext << 11) & {64{num2_ext[27]}};
         mid[28] =  (num1_ext << 12) & {64{num2_ext[28]}};
         mid[29] =  (num1_ext << 13) & {64{num2_ext[29]}};
         mid[30] =  (num1_ext << 14) & {64{num2_ext[30]}};
         mid[31] =  (num1_ext << 15) & {64{num2_ext[31]}};
        end
    else if (num2_sign) // if only num2 is negative
        begin
         num1_ext = {16'd0, num1, 16'd0};
         num2_ext = ~num2 + 1;
         mid[0]  = (num1_ext >> 16) & {64{num2_ext[0]}};
         mid[1]  = (num1_ext >> 15) & {64{num2_ext[1]}};
         mid[2]  = (num1_ext >> 14) & {64{num2_ext[2]}};
         mid[3]  = (num1_ext >> 13) & {64{num2_ext[3]}};
         mid[4]  = (num1_ext >> 12) & {64{num2_ext[4]}};
         mid[5]  = (num1_ext >> 11) & {64{num2_ext[5]}};
         mid[6]  = (num1_ext >> 10) & {64{num2_ext[6]}};
         mid[7]  = (num1_ext >> 9) & {64{num2_ext[7]}};
         mid[8]  = (num1_ext >> 8) & {64{num2_ext[8]}};
         mid[9]  = (num1_ext >> 7) & {64{num2_ext[9]}};
         mid[10] = (num1_ext >> 6) & {64{num2_ext[10]}};
         mid[11] = (num1_ext >> 5) & {64{num2_ext[11]}};
         mid[12] = (num1_ext >> 4) & {64{num2_ext[12]}};
         mid[13] = (num1_ext >> 3) & {64{num2_ext[13]}};
         mid[14] = (num1_ext >> 2) & {64{num2_ext[14]}};
         mid[15] = (num1_ext >> 1) & {64{num2_ext[15]}};
         mid[16]  = num1_ext       & {64{num2_ext[16]}};
         mid[17]  = (num1_ext << 1) & {64{num2_ext[17]}};
         mid[18]  = (num1_ext << 2) & {64{num2_ext[18]}};
         mid[19]  = (num1_ext << 3) & {64{num2_ext[19]}};
         mid[20]  = (num1_ext << 4) & {64{num2_ext[20]}};
         mid[21]  = (num1_ext << 5) & {64{num2_ext[21]}};
         mid[22]  = (num1_ext << 6) & {64{num2_ext[22]}};
         mid[23]  = (num1_ext << 7) & {64{num2_ext[23]}};
         mid[24]  = (num1_ext << 8) & {64{num2_ext[24]}};
         mid[25]  = (num1_ext << 9) & {64{num2_ext[25]}};
         mid[26] =  (num1_ext << 10) & {64{num2_ext[26]}};
         mid[27] =  (num1_ext << 11) & {64{num2_ext[27]}};
         mid[28] =  (num1_ext << 12) & {64{num2_ext[28]}};
         mid[29] =  (num1_ext << 13) & {64{num2_ext[29]}};
         mid[30] =  (num1_ext << 14) & {64{num2_ext[30]}};
         mid[31] =  (num1_ext << 15) & {64{num2_ext[31]}};
        end
    else 
        begin
          num1_ext = {16'd0, num1, 16'd0};
          num2_ext = num2;
          mid[0]  = (num1_ext >> 16) & {64{num2_ext[0]}};
          mid[1]  = (num1_ext >> 15) & {64{num2_ext[1]}};
          mid[2]  = (num1_ext >> 14) & {64{num2_ext[2]}};
          mid[3]  = (num1_ext >> 13) & {64{num2_ext[3]}};
          mid[4]  = (num1_ext >> 12) & {64{num2_ext[4]}};
          mid[5]  = (num1_ext >> 11) & {64{num2_ext[5]}};
          mid[6]  = (num1_ext >> 10) & {64{num2_ext[6]}};
          mid[7]  = (num1_ext >> 9) & {64{num2_ext[7]}};
          mid[8]  = (num1_ext >> 8) & {64{num2_ext[8]}};
          mid[9]  = (num1_ext >> 7) & {64{num2_ext[9]}};
          mid[10] = (num1_ext >> 6) & {64{num2_ext[10]}};
          mid[11] = (num1_ext >> 5) & {64{num2_ext[11]}};
          mid[12] = (num1_ext >> 4) & {64{num2_ext[12]}};
          mid[13] = (num1_ext >> 3) & {64{num2_ext[13]}};
          mid[14] = (num1_ext >> 2) & {64{num2_ext[14]}};
          mid[15] = (num1_ext >> 1) & {64{num2_ext[15]}};
          mid[16]  = num1_ext       & {64{num2_ext[16]}};
          mid[17]  = (num1_ext << 1) & {64{num2_ext[17]}};
          mid[18]  = (num1_ext << 2) & {64{num2_ext[18]}};
          mid[19]  = (num1_ext << 3) & {64{num2_ext[19]}};
          mid[20]  = (num1_ext << 4) & {64{num2_ext[20]}};
          mid[21]  = (num1_ext << 5) & {64{num2_ext[21]}};
          mid[22]  = (num1_ext << 6) & {64{num2_ext[22]}};
          mid[23]  = (num1_ext << 7) & {64{num2_ext[23]}};
          mid[24]  = (num1_ext << 8) & {64{num2_ext[24]}};
          mid[25]  = (num1_ext << 9) & {64{num2_ext[25]}};
          mid[26] =  (num1_ext << 10) & {64{num2_ext[26]}};
          mid[27] =  (num1_ext << 11) & {64{num2_ext[27]}};
          mid[28] =  (num1_ext << 12) & {64{num2_ext[28]}};
          mid[29] =  (num1_ext << 13) & {64{num2_ext[29]}};
          mid[30] =  (num1_ext << 14) & {64{num2_ext[30]}};
          mid[31] =  (num1_ext << 15) & {64{num2_ext[31]}};
        end
    end
endmodule