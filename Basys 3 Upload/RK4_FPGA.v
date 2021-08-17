`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 08/13/2021 11:48:30 AM
// Design Name: Runge Kutta Algotrithm
// Module Name: RK4_FPGA
// Project Name: 
// Target Devices: Basys 3 Board
//
// Description: 
// This is an FPGA implementation of the Runge Kutta Algorithm. 
// It is run in a Basys 3 board and the result is sown in the LCD Dispaly.
// The central button is used to start the algorithm. 
// The right button to restart the algorithm once the evaluation is completed.
// The upper button is used to check the first 4 hexadecimal of the result, otherwise the Display shows the last 4 hexadecimal. 
// The design uses the fixed number notation to express numbers so to have decimals. 
// Inputs and output are 64 bit number to have the necessary resolution. 
// Inputs are hard coded since the switches on the board could not fit four 64 bit numbers and the Board only has 106 I/O ports.
// A shift register is used to give timing to the Algorithm. As a conseqence, one run of the loop takes 4 clock cycles.
// A counter is used to load the final value into a register to output it.
// 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RK4_fpga(CLOCK, btn, btn_r, btnU, sseg, DISP_EN);
 
 parameter n = 32;
 
 input CLOCK, btn, btn_r, btnU;
 output [7:0] sseg;
 output [3:0] DISP_EN;

 wire sel_mux, ld, ld_out_reg, low_limit, limit, rst, clk, sel_mux_reg;
 wire H_sign_out, K1_sign, K2_sign, K3_sign, K4_sign;
 wire [3:0] reg_out_A, reg_out_B, reg_out_C, reg_out_D;
 
 wire signed [n-1:0] inverse_n, test_x_o, test_y_o, test_c, test_n,
                     mask_hexa_8, mask_hexa_7, mask_hexa_6, mask_hexa_5,
                     mask_hexa_4, mask_hexa_3, mask_hexa_2, mask_hexa_1,
                     out_hexa_8, out_hexa_7, out_hexa_6, out_hexa_5,
                      out_hexa_4, out_hexa_3, out_hexa_2, out_hexa_1,
                      X, Y;
 
 wire signed [n-1:0] h_out, x_mux_out, y_mux_out, x_rk4, y_rk4,
                dx_dy_1, k_1, dx_dy_2, k_2, dx_dy_3, k_3, dx_dy_4, k_4,
                k1_1_half, k2_1_half, k2_3_double, k3_2_double, 
                h_out_half;
                
 reg signed [n-1:0]
             k1_1, k1_2, k1_3, k1_4,
             k2_1, k2_2, k2_3,
             k3_1, k3_2, 
             k4_1,
             x_1, x_2, x_3, x_4, x_5,
             y_1, y_2, y_3, y_4, y_5;
    
    wire [n-1:0] count, out;
    
    // input to the runge kutta
    // x_o = 0, y_0 = 5, N = 10, 1/N = 0.1
    assign inverse_n = 32'b0000000000000000_0001100110011010;
    assign test_x_o  = 32'b0000000000000000_0000000000000000;
    assign test_y_o  = 32'b0000000000000101_0000000000000000;
    assign test_c    =   32'b0000000000000010_0000000000000000;
    assign test_n    =   32'b0000000000001010_0000000000000000;
    
    // mask final value into 8 register for 8 hexa so to display them.
    assign mask_hexa_8 = 32'b1111000000000000_0000000000000000;
    assign mask_hexa_7 = 32'b0000111100000000_0000000000000000; 
    assign mask_hexa_6 = 32'b0000000011110000_0000000000000000; 
    assign mask_hexa_5 = 32'b0000000000001111_0000000000000000;
    assign mask_hexa_4 = 32'b0000000000000000_1111000000000000; 
    assign mask_hexa_3 = 32'b0000000000000000_0000111100000000;
    assign mask_hexa_2 = 32'b0000000000000000_0000000011110000;
    assign mask_hexa_1 = 32'b0000000000000000_0000000000001111;
    // assign ld_out_reg  = 1'b1;
    
    //Clock Divider for Slow Clock 
    // 20 for good performance
      clk_divder_nbit #(.n(13)) Slow_clock(
     .clockin (CLOCK),
     .clockout (clk) );
    
    // calculate the H value in fixed number and splits it in half by shift based on sign
    H_calc H (.X_o(test_x_o), .C(test_c), .N(inverse_n), .H_sign(H_sign_out), .H(h_out));
    signed_shifter H_half( .data_in(h_out), .dbit(H_sign_out), .sel(1'b1), .data_out(h_out_half));
    
    // input muxes selecting x and y to input
    mux2_1 mux_x ( .IN_0(test_x_o), .IN_1(x_rk4), .SEL(sel_mux), .OUT(x_mux_out));
    mux2_1 mux_y ( .IN_0(test_y_o), .IN_1(y_rk4), .SEL(sel_mux), .OUT(y_mux_out));
    
    // shift register to give timing to the system
    always@(posedge clk)
    begin
 
    k1_1 <= k_1;
    k1_2 <= k1_1;
    k1_3 <= k1_2;
    k1_4 <= k1_3;
    
    k2_1 <= k_2;
    k2_2 <= k2_1;
    k2_3 <= k2_2;
    
    k3_1 <= k_3;
    k3_2 <= k3_1;
    
    k4_1 <= k_4;
    
    x_1 <= x_mux_out;
    x_2 <= x_1;
    x_3 <= x_2;
    x_4 <= x_3;
    x_5 <= x_4;
    
    y_1 <= y_mux_out;
    y_2 <= y_1;
    y_3 <= y_2;
    y_4 <= y_3;
    y_5 <= y_4;
        
    end
    
    // RK 4
    
    // Stage 1: K_1
    function_module func_calc_1( .X_IN(x_mux_out), .Y_IN(y_mux_out), .H_IN(0), .K_IN(0), .clk(clk), .K_sign(K1_sign), .DY_DX(dx_dy_1) );
    fixed_multi k_calc_1 (.num1(h_out), .num2(dx_dy_1), .num1_sign(H_sign_out), .num2_sign(K1_sign), .result(k_1), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 2: K_2
    //signed_shifter K1_half( .data_in(k1_1), .dbit(H_sign_out ^ K1_sign), .sel(1'b1), .data_out(k1_1_half));
    function_module func_calc_2( .X_IN(x_1), .Y_IN(y_1), .H_IN(h_out_half), .K_IN(k1_1 >>> 1), .clk(clk), .K_sign(K2_sign), .DY_DX(dx_dy_2) );
    fixed_multi k_calc_2 (.num1(h_out), .num2(dx_dy_2), .result(k_2), .num1_sign(H_sign_out), .num2_sign(K2_sign), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 3: K_3
    //signed_shifter K2_half( .data_in(k2_1), .dbit(H_sign_out ^ K2_sign), .sel(1'b1), .data_out(k2_1_half));
    function_module func_calc_3( .X_IN(x_2), .Y_IN(y_2), .H_IN(h_out_half), .K_IN(k2_1 >>> 1 ), .clk(clk), .K_sign(K3_sign), .DY_DX(dx_dy_3) );
    fixed_multi k_calc_3 (.num1(h_out), .num2(dx_dy_3), .result(k_3), .num1_sign(H_sign_out), .num2_sign(K3_sign), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 4: K_4 
    function_module func_calc_4( .X_IN(x_3), .Y_IN(y_3), .H_IN(h_out), .K_IN(k3_1), .clk(clk), .K_sign(K4_sign), .DY_DX(dx_dy_4) );
    fixed_multi k_calc_4 (.num1(h_out), .num2(dx_dy_4), .num1_sign(H_sign_out), .num2_sign(K4_sign), .result(k_4), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 5: calculate X and Y
    // x calculator
    // x_out = X_IN + H_IN
    rca_nb X_calc ( .a(x_4), .b(h_out), .cin(0), .sum(x_rk4), .co() );
    
    // y calculator
    // y_rk4 = y + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4)
   // signed_shifter K2_doubler( .data_in(k2_3), .dbit(1'b0), .sel(1'b0), .data_out(k2_3_double));
   // signed_shifter K3_doubler( .data_in(k3_2), .dbit(1'b0), .sel(1'b0), .data_out(k3_2_double));
    Y_calculator calc_Y( .Y_IN(y_4), .K_1(k1_4), .K_2(k2_3 <<< 1), .K_3(k3_2 <<< 1), .K_4(k4_1), .Y_OUT(y_rk4) );
    
     // store final value
     register_final register_Y(.CLK(clk), .data_in(y_1), .LD(ld), .CLR(rst), .data_out(Y));
    
     // parse final result into 8 hexadecimal to display.
     register_final register_hexa_8 (.CLK(clk), .data_in((mask_hexa_8 & Y) >> 28), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_8) );
     register_final register_hexa_7 (.CLK(clk), .data_in((mask_hexa_7 & Y) >> 24), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_7) );
     register_final register_hexa_6 (.CLK(clk), .data_in((mask_hexa_6 & Y) >> 20), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_6) );
     register_final register_hexa_5 (.CLK(clk), .data_in((mask_hexa_5 & Y) >> 16), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_5) );
     register_final register_hexa_4 (.CLK(clk), .data_in((mask_hexa_4 & Y) >> 12), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_4) );
     register_final register_hexa_3 (.CLK(clk), .data_in((mask_hexa_3 & Y) >> 8), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_3) );
     register_final register_hexa_2 (.CLK(clk), .data_in((mask_hexa_2 & Y) >> 4), .LD(ld_out_reg), .CLR(), .data_out(out_hexa_2) );
     register_final register_hexa_1 (.CLK(clk), .data_in(mask_hexa_1 & Y),        .LD(ld_out_reg), .CLR(), .data_out(out_hexa_1) );

     // used to select whenther to show the first or last 4 Hexadecimals
     assign sel_mux_reg = ~btnU;
     
     mux2_1 #(.n(4)) mux_reg_A  ( .IN_0(out_hexa_8[3:0]), .IN_1(out_hexa_4[3:0]), .SEL(sel_mux_reg), .OUT(reg_out_A) );
     mux2_1 #(.n(4)) mux_reg_B  ( .IN_0(out_hexa_7[3:0]), .IN_1(out_hexa_3[3:0]), .SEL(sel_mux_reg), .OUT(reg_out_B) );
     mux2_1 #(.n(4)) mux_reg_C  ( .IN_0(out_hexa_6[3:0]), .IN_1(out_hexa_2[3:0]), .SEL(sel_mux_reg), .OUT(reg_out_C) );
     mux2_1 #(.n(4)) mux_reg_D  (.IN_0(out_hexa_5[3:0]), .IN_1(out_hexa_1[3:0]), .SEL(sel_mux_reg), .OUT(reg_out_D) );
     
    
    
     // control for fsm
     // tells when the Nth run of the modules is reached
     comparator_nb comp( .A(count), .B(test_n << 2), .EQ(limit), .LT(), .GT());
     //comparator_nb low_comp( .A(count), .B(32'b0), .EQ(low_limit), .LT(), .GT());
     
     // up counter to check when nth loop is met
     counter_fixed_num counter( .CLK(clk), .RST(rst), .COUNT(count) );
     
     // controls the design
     // btn gives control on start and restart to the design
     // Limit is to stop the process since the Nth value of the loop is reached
     // sel_mux goes to select x and y to output
     // ld to load the final value 
     // LD to display values stored
     // rst is to clear the stored values
     fsm_rk4 fsm_rk4_calc (   .CLK(clk), 
                              .BTN(btn),
                              .BTN_R(btn_r),
                              .LIMIT(limit), 
                              .LD(ld), 
                              .LD_DISP(ld_out_reg),
                              .SEL(sel_mux),
                              .RST(rst)
                              );  
    
    // Seven segments data to display
        our_sseg Values( 
                              .clk (CLOCK),
                              .regA (reg_out_A), 
                              .regB (reg_out_B), 
                              .regC (reg_out_C), 
                              .regD (reg_out_D),
                              .seg (sseg),
                              .Anodes(DISP_EN)
                              );
                              
                              
endmodule
