% sig_dig.m test script file

input_mat = [ 123.45 234.56 ; 234.56 123.45];
expected_output_mat_1Eneg1 = [ 12 23; 23 12]
expected_output_mat_1E1 = [1235 2346; 2346 1235]

sig = @sig_dig
output_mat_1Eneg1 = sig_dig(input_mat, 1E-1)
output_mat_1E1 = sig_dig(input_mat, 1E1)

if isequal(output_mat_1Eneg1, expected_output_mat_1Eneg1)
    disp('sig dig.m performing correctly with 10E-1')
else
    disp('sig dig.m performing incorrectly with 10E-1')
end

if isequal(output_mat_1E1, expected_output_mat_1E1)
    disp('sig dig.m performing correctly with 10E1')
else
    disp('sig dig.m performing incorrectly with 10E1')
end