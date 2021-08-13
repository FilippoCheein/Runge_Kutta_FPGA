`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Filippo Cheein
// 
// Create Date: 07/23/2021 03:27:30 PM
// Design Name:
// Module Name: usr_nb
// Project Name: Runge-Kutta
// Target Devices: BAsys 3
// Tool Versions: 
// Description: universal shift register
//
// instantiation
// usr_nb(.data_in(), .dbit(), .sel(), .clk(), .clr(), .data_out());
//
// mult by 2: usr_nb(.data_in(in), .dbit(0), .sel(3), .clk(clk), .clr(0), .data_out(out));
//
// divide by 2: usr_nb(.data_in(in), .dbit(0), .sel(2), .clk(clk), .clr(0), .data_out(out));
//

module usr_nb(data_in, dbit, sel, clk, clr, data_out); 
    
    parameter n = 16; 
    input  [n-1:0] data_in; 
    input  dbit, clk, clr; 
    input  [1:0] sel; 
    output reg [n-1:0] data_out; 
    
    always @(posedge clr, posedge clk)
    begin 
        if (clr == 1)     // asynch reset
           data_out <= 0;
        else 
           case (sel) 
              0: data_out <= data_out;                // hold value
              1: data_out <= data_in;                 // load
              2: data_out <= {data_out[n-2:0],dbit};  // shift left
              3: data_out <= {dbit,data_out[n-1:1]};  // shift right
              default data_out <= 0; 
           endcase 
    end
    
endmodule

