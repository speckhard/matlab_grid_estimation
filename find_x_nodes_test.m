% Script to test find_x_nodes.m

test_branch_list = [1 2; 2 3; 2 4; 1 5];
expected_leaf_list = [3 4 5];
expected_2branch_list = [1];
expected_3branch_list = [2];

find_xnodes = @find_x_nodes
output_leaf_list = find_xnodes(test_branch_list,1)
output_2branch_list = find_xnodes(test_branch_list,2)
output_3branch_list = find_xnodes(test_branch_list, 3)

if isequal(output_leaf_list, expected_leaf_list)
    disp('find x nodes function perofrming correctly for leafs')
else
    disp('find x nodes function performing incorrectly for leafs')
end

if isequal(output_2branch_list, expected_2branch_list)
    disp('find x nodes function perofrming correctly for 2branch nodes')
else
    disp('find x nodes function performing incorrectly for 2branch nodes')
end

if isequal(output_3branch_list, expected_3branch_list)
    disp('find x nodes function perofrming correctly for 3branch nodes')
else
    disp('find x nodes function performing incorrectly for 3branch nodes')
end

