% find leaf nodes test script

test_branch_list = [1 2; 2 3; 2 4; 1 5];
expected_leaf_list = [3 4 5];

find_leafs = @find_leaf_nodes
output_leaf_list = find_leafs(test_branch_list)

if isequal(output_leaf_list, expected_leaf_list)
    disp('find leaf nodes function perofrming correctly')
else
    disp('find leaf nodes function performing incorrectly')
end

    

