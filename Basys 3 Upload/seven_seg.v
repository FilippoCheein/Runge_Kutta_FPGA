`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2021 05:05:10 PM
// Design Name: 
// Module Name: seven_seg
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

module cntr_up_clr_nb(clk, clr, up, ld, D, count, rco); 
    input  clk, clr, up, ld; 
    input  [n-1:0] D; 
    output   reg [n-1:0] count = 0; 
    output   reg rco; 

    //- default data-width 
    parameter n = 8; 
    
    always @(posedge clr, posedge clk)
    begin 
        if (clr == 1)       // asynch reset
           count <= 0;
        else if (ld == 1)   // load new value
           count <= D; 
        else if (up == 1)   // count up (increment)
           count <= count + 1;  
    end 
       
    
    //- handles the RCO, which is direction dependent
    always @(count, up)
    begin 
       if ( up == 1 && &count == 1'b1)
          rco = 1'b1;
       else if (up == 0 && |count == 1'b0)
          rco = 1'b1;
       else 
          rco = 1'b0; 
    end
    
endmodule

//7-Segment display module
module our_sseg(clk, seg, Anodes, regA, regB, regC, regD);// regA_2, regB_2, regC_2, regD_2);
    input clk;
    //input [3:0] P_State;
    input signed [3:0] regA,   regB,   regC,   regD;
               // regA_2, regB_2, regC_2, regD_2;
    
    wire fastclock;
    wire [1:0]count;
    wire [3:0] value;
    
    output reg [7:0] seg;
    output reg [3:0] Anodes;
    
    //clock divider for anode selection
    clk_divder_nbit #(.n(13)) Fast(
        .clockin (clk),
        .clockout (fastclock)
        );
  
    cntr_up_clr_nb #(.n(2)) MY_CNTR_insseg (
           .clk   (fastclock), 
           .clr   (), 
           .up    (1), 
           .ld    (0), 
           .D     (00), 
           .count (count), 
           .rco   ()   );
  
    mux_4t1_nb  #(.n(4)) my_4t1_mux_out  (
           .SEL   (count), 
           .D0    (regA),
           .D1    (regB),
           .D2    (regC), 
           .D3    (regD),
           .D_OUT (value) );  
                             
                             
    // rapid flickering of anodes
    always @ (count)
    begin 
        case (count)
           0 : Anodes = 4'b0111;
           1 : Anodes = 4'b1011;
           2 : Anodes = 4'b1101;
           3 : Anodes = 4'b1110;
        endcase
    end
    
    //Seven segment display data
    always @ (value)
    begin
        case (value)
           0 : seg = 8'b00000011;
           
           1 : seg = 8'b10011111;
           
           2 : seg = 8'b00100101;
           
           3 : seg = 8'b00001101;
           
           4 : seg = 8'b10011001;
           
           5 : seg = 8'b01001001;
           
           6 : seg = 8'b01000001;
           
           7 : seg = 8'b00011111;
           
           8 : seg = 8'b00000001;
           
           9 : seg = 8'b00001001;
           
           10 : seg = 8'b00010001;
           
           11 : seg = 8'b00000001;
           
           12 : seg = 8'b01100011;
           
           13 : seg = 8'b10000101;
           
           14 : seg = 8'b01100001;
           
           15 : seg = 8'b01110001;
        endcase
    end
    
endmodule
