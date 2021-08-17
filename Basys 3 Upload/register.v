`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 08/13/2021 11:47:37 AM
// Design Name: Runge Gutta Algorithm for FPGA
// Module Name: register_final_value
// Project Name: RK4_FPGA
// Target Devices: Basys 3 Board
// 
// Description:
// Register file to store data. 
// 
// Revision:
// Revision 0.01 - File Created
// 
//////////////////////////////////////////////////////////////////////////////////


// register to store output
module register_final(CLK, data_in, LD, CLR, data_out);

 input LD, CLR, CLK;
 input signed [31:0] data_in;
 output reg signed [31:0] data_out = 0;
 
    always @(posedge CLR, posedge CLK)
    begin
         if (CLR)
            data_out <= 32'b0000000000000000_0000000000000000;
         else if(LD)
            data_out <= data_in;
    end

endmodule