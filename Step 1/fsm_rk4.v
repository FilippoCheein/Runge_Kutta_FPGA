`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: URPC
// Engineer: Filippo Cheein
// 
// Create Date: 07/14/2021 11:28:01 AM
// Design Name: 
// Module Name: fsm_rk4
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

module RK4_fpga(clk, x_o, y_o, c, n_iteration, sel_in, btn, X, Y);
 
 parameter n = 32;
 input clk, btn, sel_in;
 input [n-1:0] x_o, y_o, c, n_iteration;
 output signed [n-1:0] X, Y;

 wire sel, ld, low_limit, limit, rst;
 wire H_sign_out, K1_sign, K2_sign, K3_sign, K4_sign;
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
    
    reg [31:0] count;
    
    H_calc H (.X_o(x_o), .C(c), .N(n_iteration), .H_sign(H_sign_out), .H(h_out));
    signed_shifter H_half( .data_in(h_out), .dbit(H_sign_out), .sel(1'b1), .data_out(h_out_half));
    
    // input muxes
    // sel_in for testing
    mux2_1 mux_x ( .IN_0(x_o), .IN_1(x_rk4), .SEL(sel_in), .OUT(x_mux_out));
    mux2_1 mux_y ( .IN_0(y_o), .IN_1(y_rk4), .SEL(sel_in), .OUT(y_mux_out));
    
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
    function_module func_calc_1( .X_IN(x_1), .Y_IN(y_1), .H_IN(0), .K_IN(0), .clk(clk), .K_sign(K1_sign), .DY_DX(dx_dy_1) );
    fixed_multi k_calc_1 (.num1(h_out), .num2(dx_dy_1), .num1_sign(H_sign_out), .num2_sign(K1_sign), .result(k_1), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 2: K_2
    signed_shifter K1_half( .data_in(k1_1), .dbit(H_sign_out ^ K1_sign), .sel(1'b1), .data_out(k1_1_half));
    function_module func_calc_2( .X_IN(x_2), .Y_IN(y_2), .H_IN(h_out_half), .K_IN(k1_1_half), .clk(clk), .K_sign(K2_sign), .DY_DX(dx_dy_2) );
    fixed_multi k_calc_2 (.num1(h_out), .num2(dx_dy_2), .result(k_2), .num1_sign(H_sign_out), .num2_sign(K2_sign), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 3: K_3
    signed_shifter K2_half( .data_in(k2_1), .dbit(H_sign_out ^ K2_sign), .sel(1'b1), .data_out(k2_1_half));
    function_module func_calc_3( .X_IN(x_3), .Y_IN(y_3), .H_IN(h_out_half), .K_IN(k2_1_half), .clk(clk), .K_sign(K3_sign), .DY_DX(dx_dy_3) );
    fixed_multi k_calc_3 (.num1(h_out), .num2(dx_dy_3), .result(k_3), .num1_sign(H_sign_out), .num2_sign(K3_sign), .overflow(), .precisionLost(), .result_full() );
    
    // Stage 4: K_4 
    function_module func_calc_4( .X_IN(x_4), .Y_IN(y_4), .H_IN(h_out), .K_IN(k3_1), .clk(clk), .K_sign(K4_sign), .DY_DX(dx_dy_4) );
    fixed_multi k_calc_4 (.num1(h_out), .num2(dx_dy_4), .num1_sign(H_sign_out), .num2_sign(K4_sign), .result(k_4), .overflow(), .precisionLost(), .result_full() );
    
    // x calculator
    // x_out = X_IN + H_IN
    rca_nb adder_1 ( .a(x_5), .b(h_out), .cin(0), .sum(x_rk4), .co() );
    
    // y calculator
    // y_rk4 = y + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4)
    signed_shifter K2_doubler( .data_in(k2_3), .dbit(1'b0), .sel(1'b0), .data_out(k2_3_double));
    signed_shifter K3_doubler( .data_in(k3_2), .dbit(1'b0), .sel(1'b0), .data_out(k3_2_double));
    Y_calculator calc_Y( .Y_IN(y_5), .K_1(k1_4), .K_2(k2_3_double), .K_3(k3_2_double), .K_4(k4_1), .Y_OUT(y_rk4) );
    
    
    
    
endmodule

// register to store output
module register_final(CLK, data_in, LD, CLR, data_out);

 input LD, CLR, CLK;
 input [31:0] data_in;
 output reg [31:0] data_out;
 
    always @(posedge LD, posedge CLR)
    begin
        if(CLR == 1)
            data_out <= 0;
        else if(LD == 1)
            data_out <= data_in;
    end

endmodule

/*

// generate new x and y
module rk4(CLK, H_in, x_in, y_in, UP, x_out, y_out, CNT);

 input CLK, UP;
 input [7:0] H_in, x_in, y_in;
 output reg [7:0] x_out, y_out, CNT;

 wire [7:0] H_calc, H_clac_half, x_calc, y_calc;
 reg [14:0] k_1, k_2, k_3, k_4;
 
 assign H_calc = H_in;
 assign H_clac_half = H_in >> 1;
 assign x_calc = x_in;
 assign y_calc = y_in;

 function [7:0] dy_dx;
    input [7:0] x, y;
 
        begin
            dy_dx = (x - y)/2;        
        end
 
 endfunction
     
     always @(posedge CLK)
     begin
         if(UP)
           begin
             CNT = CNT + 1;
             
             k_1 = H_calc * dy_dx(x_calc, y_calc);
             k_2 = H_calc * dy_dx(x_calc + H_clac_half , y_calc + k_1/2);
             k_3 = H_calc * dy_dx(x_calc + H_clac_half , y_calc + k_2/2);
             k_4 = H_calc * dy_dx(x_calc + H_calc , y_calc + k_3);
             
             x_out = x_calc + H_calc;
             y_out = y_calc + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4);
           end
          else
           CNT = 0;
           
     end
     
endmodule
*/


/*
    always@(posedge clk)
    begin
        if (rst)
           count <= 32'b0;
        else
           count <= count + 32'b1;
    
    end

     // control for fsm
     comparator_nb comp( .A(count), .B(16'b0000000000110010), .EQ(limit), .LT(), .GT());
     comparator_nb low_comp( .A(count), .B(16'b0), .EQ(low_limit), .LT(), .GT());
       
     register_final register_Y(.CLK(clk), .data_in(y_rk4), .LD(ld), .CLR(0), .data_out(Y));
     
     fsm_rk4 fsm_rk4_calc (   .CLK(clk), 
                              .BTN(btn),
                              .LOW_LIM(low_limit), 
                              .LIMIT(limit), 
                              .LD(ld), 
                              .SEL(sel),
                              .RST(rst)
                              ); 

*/
module fsm_rk4(CLK, BTN, LOW_LIM, LIMIT, LD, SEL, RST);

input CLK, BTN, LOW_LIM, LIMIT;
output reg LD, SEL, RST;

reg [1:0] PS, NS;
parameter [1:0] st_wait = 2'b00, st_calc = 2'b01;

    always @ (posedge CLK)
        if (CLK == 1)
            PS <= NS;
          
    always @ (BTN, PS, LIMIT, LOW_LIM)
    begin
    
    // assign all outputs
    SEL = 0; 
     LD = 0;
     
      case (PS)
     
         st_wait:
         begin
             if (!BTN)
              begin
               SEL = 0;
               RST = 1;
              end
             else 
             begin
               NS = st_calc;
             end
         end
         
         st_calc: 
         begin
             
/*              if (LOW_LIM)
                  begin
                      SEL = 1;
                      RST = 0;
                      // UP = 1;
                      NS = st_calc;
                  end
              else */ 
              if(!LIMIT)
                 begin
                    SEL = 1;
                    RST = 0;
                    LD = 0;
                    NS = st_calc;
                 end
               else if (LIMIT)
                 begin
                    SEL = 0;
                    LD = 1;
                    RST = 1;
                    NS = st_wait;
                 end
               else
                    NS = st_wait;
         end
       
         default: NS = st_wait;
       
      endcase
    
    end
      
endmodule
