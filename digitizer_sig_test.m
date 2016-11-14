%% Digitizer Sig Test Script
% Import function.
digitizer = @digitize_sig;

% Input matrix
test_matrix=[18 19, -1 0];

% Perform 8 bit digitization
output_matrix = digitizer(test_matrix,8,'local','local');

expected_bin_size = (max(max(test_matrix))+1)/(2^8 -1);
expected_output_matrix = round((test_matrix+1)./expected_bin_size);

if expected_output_matrix == output_matrix
    disp('digitizer function performing as expected')
else
    disp('digitizer function performing incorrectly')
end
