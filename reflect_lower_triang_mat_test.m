% Script to test reflect lower triang mat.m fxn

% Our input is a lower triangular matrix, the diag shouldn't matter
input_mat = [0 0 0; 2 0 0 ; 5 1 0]
expected_output_mat = [ 0 2 5; 2 0 1; 5 1 0];

reflect_mat = @reflect_lower_triang_mat;
output_mat = reflect_mat(input_mat)

if isequal(output_mat, expected_output_mat)
    disp('reflect_lower_triang_mat.m fxn working correctly')
else
    disp('reflect_lower_triang_mat.m fxn working incorrectly')
end
