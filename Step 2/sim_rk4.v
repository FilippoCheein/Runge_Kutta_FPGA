`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/15/2021 05:50:54 PM
// Design Name: 
// Module Name: sim_rk4
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


module sim_rk4();

reg test_clk, BTN, SEL_IN;
reg [31:0] test_x_o, test_y_o, test_c, test_n; 
wire [31:0]test_x_out, test_y_out;

RK4_fpga uut( .clk(test_clk), 
              .x_o(), 
              .y_o(), 
              .c(), 
              .n_iteration(), 
              .sel_in(SEL_IN),
              .btn(BTN),
              .X(), 
              .Y(test_y_out)
              );

wire [31:0] result;
wire [63:0] full;
reg [31:0] num_1_mult, num_2_mult;

// fixed_multi test (.num1(num_1_mult), .num2(num_2_mult), .result(result), .overflow(), .precisionLost(), .result_full(full) );

initial begin
  /*
    test_x_o <= 32'b0000000000000000_0000000000000000;
    test_y_o <= 32'b0000000000000001_0000000000000000;
    test_c <=   32'b0000000000000010_0000000000000000;
    test_n <=   32'b0000000000001010_0000000000000000;
   */
    
    SEL_IN <= 0; #50
    SEL_IN <= 1;
    BTN <= 1; #50
    BTN <= 0;
end

always 
    begin
    test_clk = 0; #5;
    test_clk = 1; #5;
    end

endmodule
