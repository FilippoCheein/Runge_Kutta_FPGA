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

reg test_clk, BTN, SEL_IN, BTN_R;
reg [31:0] test_x_o, test_y_o, test_c, test_n; 
wire [31:0]test_x_out, test_y_out;

RK4_fpga uut( .CLOCK(test_clk), 
              .btn(BTN),
              .btn_r(BTN_R),
              .sseg(), 
              .DISP_EN()
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
    BTN_R = 0;
    BTN = 1; #10000000
    BTN = 0;
    
end

always 
    begin
    test_clk = 0; #5;
    test_clk = 1; #5;
    end

endmodule
