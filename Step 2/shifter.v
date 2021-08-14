`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2021 04:51:34 PM
// Design Name: 
// Module Name: shifter
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 07/23/2021 03:27:30 PM
// Design Name:
// Module Name: Signed_Shifter
// Project Name: Runge-Kutta
// Target Devices: Basys 3
// Tool Versions: 
// Description: shifter
//          take sign ointo account when shifting
// instantiation
// usr_nb(.data_in(), .dbit(), .sel(), .clk(), .clr(), .data_out());
//
// mult by 2: signed_shifter(.data_in(in), .dbit(sign_flag), .sel(0), .data_out(out));
// divide by 2: signed_shifter(.data_in(in), .dbit(sign_flag), .sel(1), .data_out(out));
//

module signed_shifter(data_in, dbit, sel, data_out); 
    
    parameter n = 32; 
    input  signed [n-1:0] data_in; 
    input  dbit; 
    input  sel; 
    output reg signed [n-1:0] data_out; 
    
    always @(data_in)
    begin 
           case (sel) 
              0: data_out = {data_in[n-2:0],dbit};  // shift left - multiply
              1: data_out = {dbit,data_in[n-1:1]};  // shift right - divider
              default data_out = 0; 
           endcase 
    end
    
endmodule