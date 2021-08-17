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
//////////////////////////////////////////////////////////////////////////////////

module fsm_rk4(CLK, BTN, BTN_R, LIMIT, LD, LD_DISP, SEL, RST);

input CLK, BTN, BTN_R, LIMIT;
output reg LD, LD_DISP, SEL, RST;

reg [1:0] PS, NS;
parameter [1:0] st_wait = 2'b00, st_calc = 2'b01, st_display = 2'b10;

    always @ (posedge CLK)
        if (CLK == 1)
            PS <= NS;
          
    always @ (BTN, BTN_R, PS, LIMIT)
    begin
    
    // assign all outputs
     SEL = 0; 
     RST = 0;
     LD  = 0;
     LD_DISP = 0;
     
      case (PS)
     
         st_wait:
         begin
             if (!BTN)
              begin
               SEL = 0;
               RST = 1;
               LD = 0;
               NS = st_wait;
              end
             else 
             begin
               RST = 1;
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
                    LD_DISP = 1;
                    NS = st_calc;
                 end
               else if (LIMIT)
                 begin
                    SEL = 0;
                    LD = 1;
                    RST = 0;
                    LD_DISP = 0;
                    NS = st_display;
                 end
               else
                    NS = st_wait;
         end
         
         st_display:
         begin
         
             if(!BTN_R)
                 begin
                 SEL = 0;
                 LD = 0;
                 RST = 0;
                 LD_DISP = 1;
                 
                 NS = st_display;
                 end
             else if(BTN_R)
                 begin 
                 SEL = 0;
                 LD = 0;
                 RST = 0;
                 LD_DISP = 0;
                 
                 NS = st_wait;
                 end
            else 
                NS = st_display;
                
         end
       
         default: NS = st_wait;
       
      endcase
    
    end
      
endmodule
