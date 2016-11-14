% Test script for consider_derivative matlab function.
% Author: DTS
% First Created: 10/21/2016

% This function should update the voltage measurement input matrix to have
% each value subracted by the previous value expect for the initial
% observation. 

test_voltage_meas_matrix = [3 4 9 12; 3 3 7 2; 10 12 3 4];
% We expect the first row of data to be divided by the first measurement in
% the test slack bus and the second row of the voltage measurements data to
% be divided by the second row of the slack bus. 
expected_voltage_meas_matrix = [ 0 -1 -2 -10; 7 9 -4 2];

test_function = @consider_derivative;
[output_voltage_meas_matrix] = ...
    test_function(test_voltage_meas_matrix);

if isequal(output_voltage_meas_matrix, expected_voltage_meas_matrix)
    disp(['consider_derivative function performing as expected', ...
    ' on voltage measurement data'])
else
    disp(['consider_derivative function performs incorrectly', ...
    ' on voltage measurement data'])
end
