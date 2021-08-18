% Runge Gutta MATLAB Implementation
%
% Author: Filippo Cheein

function [y, x] = RK4(x_o, y_o, c, N)
% [y, x] = RK4 [x_o, y_o, c, N]
%
% Input
% 
% x_o :  left end of range
% y_o :  initial value of y, value of y at x_o, y(x_o)
% c   :  right end of range
% N   :  Number of steps
% 
% Output
%
% y: final value of y
% x: final value of x
%

% Step 1: set up
% Verilog: Register for inputs
    
    h = (c - x_o)/N % step size
    x = x_o;
    y = y_o;

% Step 2: loop - FSM?
    for n = 1:N
        disp(n);
        % Step 3: set ks
        % Verilog: Function module - gets x and y arguments and outputs ks
        k_1 = h * dy_dx_RK4(x, y)
        
        
        k_2 = h * dy_dx_RK4(x + h/2, y + k_1/2)
        
        k_3 = h * dy_dx_RK4(x + h/2, y + k_2/2)
        
        k_4 = h * dy_dx_RK4(x + h, y + k_3)
        
        % Step 4: find next x and y
        % Verilog: Final x, y calculator 
        x = x + h
        
        y = y + (1/6)*(k_1 + 2*k_2 + 2*k_3 + k_4)
        
    end

end


