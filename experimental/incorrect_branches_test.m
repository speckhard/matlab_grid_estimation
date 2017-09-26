% Test Script for incorrect_branches.m function

% Create a true branch matrix
true_branch_mat = [1 2; 2 3; 2 4; 3 5; 5 6];
est_branch_mat = [ 1 4; 4 2; 2 3; 3 5; 3 6];

expected_incorrect_branches = [1 4; 3 6];

find_wrong_branches = @incorrect_branches;
returned_incorrect_branches = find_wrong_branches(...
    true_branch_mat, est_branch_mat)

if isequal(returned_incorrect_branches, expected_incorrect_branches)
    disp('incorrect_branches.m function working correctly.')
else
    disp('incorrect branches.m function working incorrectly.')
end
