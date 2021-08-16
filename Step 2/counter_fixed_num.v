`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2021 12:43:12 PM
// Design Name: 
// Module Name: counter_fixed_num
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
