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
