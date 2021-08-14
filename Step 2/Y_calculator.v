// Module to calculate y
// 
// y = y + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4);
//
// Instantiation 
// Y_calculator( .Y_IN(), .K_1(), .K_2(), .K_3(), .K_4(), .Y_OUT() );
//
module Y_calculator(Y_IN, K_1, K_2, K_3, K_4, Y_OUT);

 parameter n = 32;
 input [n-1:0] Y_IN, K_1, K_2, K_3, K_4;
 output [n-1:0] Y_OUT;

 wire [n-1:0] sum_k1_k2, sum_k3_k4, mult_K, sum_out;
 
 // sum_out = (k_1 + 2*k_2)
 rca_nb adder_k1_k2 ( .a(K_1), .b(K_2), .cin(0), .sum(sum_k1_k2), .co());
 
 // sum_out = (2*k_3 + k_4)
 rca_nb adder_k3_k4 ( .a(K_3), .b(K_4), .cin(0), .sum(sum_k3_k4), .co());
 
 
 // sum_out = (k_1 + 2*k_2 + 2*k_3 + k_4)
 rca_nb adder_k ( .a(sum_k1_k2), .b(sum_k3_k4), .cin(0), .sum(sum_out), .co());
 
 // multiply Ks with 1/6
 //
 // mult_K = (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4)
 fixed_multi mult (.num1(32'b0000000000000000_0010101010101011), .num2(sum_out),  .num1_sign(1'b0), .num2_sign(sum_out[31]), .result(mult_K), .overflow(), .precisionLost(), .result_full() );
 
 // add Y to multiplication result
 //
 // y = y + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4);
 rca_nb add_y(.a(Y_IN), .b(mult_K), .cin(0), .sum(Y_OUT), .co());
 
endmodule