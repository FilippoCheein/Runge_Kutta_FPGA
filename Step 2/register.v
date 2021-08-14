`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2021 11:47:37 AM
// Design Name: 
// Module Name: register_final_value
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


// register to store output
module register_final(CLK, data_in, LD, CLR, data_out);

 input LD, CLR, CLK;
 input [31:0] data_in;
 output reg [31:0] data_out;
 
    always @(posedge CLR, posedge CLK)
    begin
         if (CLR)
            data_out <= 32'b0000000000000000_0000000000000000;
         else if(LD)
            data_out <= data_in;
    end

endmodule