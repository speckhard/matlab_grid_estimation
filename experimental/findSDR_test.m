% Test script for findSDR matlab file.

% The input estimated list of branches is:
test_estimated_branches_list = [1 2; 3 2; 4 5; 8 9; 2 8];
% The input correct branches list is the same except with two pairs
% reversed and the last branch completely different. 
test_correct_branches_list = [1 2; 2 3; 5 4; 8 9; 3 8];

% We expect to four correct branches accounted for. 
expected_num_of_branches_correct = 4;

% We expcet a % SDR of 4/5*100:
expected_SDR = 80;

test_function = @findSDR;
[output_number_branches_correct, output_branch_SDR] = ...
    test_function(test_estimated_branches_list, ...
    test_correct_branches_list);

if isequal(output_number_branches_correct, ...
        expected_num_of_branches_correct)
    disp(['find SDR function performing as expected', ...
    ' in finding correct branch number'])
else
    disp(['find SDR function performs incorrectly', ...
    ' in branch number correct function'])
end

if isequal(output_branch_SDR, expected_SDR)
    disp(['find SDR function performing as expected', ...
    ' in branch number correct function'])
else
    disp(['find SDR function performs incorrectly', ...
    ' in finding branch SDR'])
end
