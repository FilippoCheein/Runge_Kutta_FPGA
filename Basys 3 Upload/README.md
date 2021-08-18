The Runge Gutta Algorithm is widely used to solve Ordinary Diferential Equations (ODE). This method is a popular scheme for solving initial value problems because it
has a fast rate of convergence and is relatively easy to program.

A typical Runge Gutta Algorithm taken from the book "Fundamentals of Differential Equations 8th ed" is shown below:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_Algorithm_Book.PNG?raw=true)

A Matlab translation can be found in the main folder. 

This Method was translated in Hadrware by using Verilog and then uploaded in a Xilinx Basys 3 Board. The Black Box Diagram and FSM State Diagram can be found below as well as a few simulation results.

Black Box Design Diagram:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_Black_Box_Diagram_Final.PNG?raw=true)


FSM State Diagram:

![alt text](https://github.com/FilippoCheein/Runge_Kutta_FPGA/blob/main/Basys%203%20Upload/RK4_FSM_State_Diagram.PNG?raw=true)
