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
    RST = 1;
     LD = 0;
     
      case (PS)
     
         st_wait:
         begin
             if (!BTN)
              begin
               SEL = 0;
               RST = 0;
               LD = 0;
               NS = st_wait;
              end
             else 
             begin
               NS = st_calc;
             end
         end
         
         st_calc: 
         begin
             
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
                    RST = 0;
                    NS = st_wait;
                 end
               else
                    NS = st_wait;
         end
       
         default: NS = st_wait;
       
      endcase
    
    end
      
endmodule
