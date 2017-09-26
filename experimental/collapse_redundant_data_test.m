% Test script for collapse_redudant_data matlab file.

% The input test vector has several columns that are redundant. The test
% matrix has columns 3 and 1 as the same data. Columns 5 and 2 are also the
% same.
test_voltage_meas_matrix = [3 4 3 9 4 12; 3 5 3 8 5 1; 3 6 3 7 6 2];
% We expect Columns 3 and Columns 5 to be removed from the data set.
expected_voltage_meas_matrix = [3 4 9 12; 3 5 8 1; 3 6 7 2];

% We also input a test branch matrix for the data. 
test_branch_matrix = [1 3; 1 2; 4 5; 5 6; 3 5];
% We expect a branch to 
expected_branch_matrix = [ 1 1; 1 2; 3 2; 2 4; 1 2];

test_function = @collapse_redundant_data;
[output_voltage_meas_matrix, output_branch_matrix] = ...
    test_function(test_voltage_meas_matrix, test_branch_matrix);

if isequal(output_voltage_meas_matrix, expected_voltage_meas_matrix)
    disp(['collapse_redundant_data function performing as expected', ...
    ' on voltage measurement data'])
else
    disp(['collapse_redundant_data function performs incorrectly', ...
    ' on voltage measurement data'])
end

if isequal(output_branch_matrix, expected_branch_matrix)
    disp(['collapse_redundant_data function performing as expected', ...
    ' on branch data'])
else
    disp(['collapse_redundant_data function performs incorrectly', ...
    ' on branch data'])
end
    

