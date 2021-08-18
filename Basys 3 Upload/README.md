The Runge Gutta Algorithm is widely used to solve Ordinary Diferential Equations (ODE). This method is a popular scheme for solving initial value problems because it
has a fast rate of convergence and is relatively easy to program.

A typical Runge Gutta Algorithm taken from the book "Fundamentals of Differential Equations 8th ed" is shown below:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_Algorithm_Book.PNG?raw=true)

A Matlab translation can be found in the main folder. 

This Method was translated in hardware by using Verilog and then uploaded in a Xilinx Basys 3 Board. The Black Box Diagram and FSM State Diagram can be found below as well as a few simulation results.

There is an FSM that control which step should be done by the machine. The main step is the calculation step, while the others are to give control to the board and show the results so that can be checked. 
The calculation stage is timed by a shift register to make sure each stage is functioning correctly.

Black Box Design Diagram:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_Black_Box_Diagram_Final.PNG?raw=true)


FSM State Diagram:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_FSM_State_Diagram.PNG?raw=true)


Simulation:

Case 1:  N = 10, x_o = 0, y_o = -1, c = 2:
* Result for Case 1:  N = 10, x_o = 0, y_o = -1, c = 2:
Result Hexadecimal (Fixed Numbers) : 0000 5E2F
Result Binary      (Fixed Numbers) : 0000 0000 0000 0000 0101 1110 0010 1111
Result in Decimals                 : 0 + 2^-2 + 2^-4 + 2^-5 + 2^-6 + 2^-7 + 2^-11 + 2^-13 + 2^-14 + 2^-15 + 2^-16 = 0.3679   

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_1.JPG?raw=true)

Case 2:  N = 10, x_o = -1, y_o = -1, c = 2

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_2.JPG?raw=true)

Case 3:  N = 10, x_o = -1, y_o = 1, c = 2

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_3.JPG?raw=true)

Case 4:  N = 10, x_o = 0, y_o = 1, c = 2

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_4_1.JPG?raw=true)

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_4_2.JPG?raw=true)


Case 4:  N = 10, x_o = 0, y_o = 0, c = 2

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/Simulation%20Pic/test_5_1.JPG?raw=true)
