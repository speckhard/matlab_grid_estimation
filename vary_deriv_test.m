% Var Deriv Test Script

% Ensure that the function is perfoming as expected. 

test_mat = [ 1 2 6; 8 9 12; 18 22 1; 30 34 19]
test_delay = 2;
expected_resulting_mat = [ 18-1,22-2, 1-6; 30-8, 34-9, 19-12]

var_deriv_step = @var_deriv;
output_mat = var_deriv(test_mat, test_delay)

if isequal(output_mat, ...
        expected_resulting_mat)
    disp(['varying step deriv fxn performing correctly'])
else
    disp(['varying step deriv fxn performing incorrectly'])
end
