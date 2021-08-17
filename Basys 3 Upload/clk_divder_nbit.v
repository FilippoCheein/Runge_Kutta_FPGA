`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2021 10:30:49 AM
// Design Name: 
// Module Name: clk_divder_nbit
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


module clk_divder_nbit(clockin, clockout); 
    input clockin; 
    output wire clockout; 

    parameter n = 13; 
    reg [n:0] count = 0; 
    
    always@(posedge clockin) 
    begin 
        count <= count + 1; 
    end 

    assign clockout = count[n]; 
endmodule 