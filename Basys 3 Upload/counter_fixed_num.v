`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 08/13/2021 12:43:12 PM
// Design Name: Runge Gutta Algorithm for FPGA
// Module Name: counter_fixed_num
// Project Name: 
// Target Devices: Basys 3 Board
//
// Description: 
// This is a counter counting with fixed numbers. 
// In this way it can be compared to the 4*N. 
// 4 are the clock cycle for one run of the loop. 
// 
// Dependencies: 
// 
// Revision:
// 
//////////////////////////////////////////////////////////////////////////////////

//
//  counter_fixed_num( .CLK(), .RST(), .COUNT() );
//
module counter_fixed_num( CLK, RST, COUNT);
    parameter n = 32;
    input CLK, RST;
    output reg [n-1:0] COUNT;
    
    always@(posedge CLK, negedge RST)
        begin
            if (RST)
               COUNT <= 32'b0000000000000000_0000000000000000;
            else
               COUNT <= COUNT + 32'b0000000000000001_0000000000000000;
        
        end
    
endmodule
