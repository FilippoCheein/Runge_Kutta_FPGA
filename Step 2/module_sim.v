`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2021 03:47:56 PM
// Design Name: 
// Module Name: module_sim
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


module module_sim();

    reg [15:0] num1, num2; 
    wire [31:0] multiplication, fix_mul, out;

    initial begin
       
       num1 = 16'b00000000_00000000;
       num2 = 16'b00000001_00000000;
       
    end
    
    multiplier test( .A(16'b11111111_00000000), .B(16'b00000000_10000000), .mult(multiplication) ); 
    fixed_multi test_fixed (  .num1(32'b1111111111111111_1000000000000000), .num2(32'b1111111111111111_0000000000000000), .num1_sign(0), .num2_sign(1), .result(fix_mul), .overflow(), .precisionLost(), .result_full() );
    function_module func_calc_2( .X_IN(num1), .Y_IN(num2), .H_IN(16'b00000000_000000000), .K_IN(16'b00000000_000000000), .clk(), .DY_DX(out) );



endmodule
