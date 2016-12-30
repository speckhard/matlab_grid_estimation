% err_node_list test script
num_nodes = 5;
err_freq_list = [ 1 0 2 0 0];
incorrect_branch_mat = [ 1 2; 1 3; 3 5];
expected_err_freq_list = [ 2 1 3 0 1];

find_err_list = @err_node_list;

return_err_list = err_node_list(num_nodes, incorrect_branch_mat, ...
    err_freq_list);

if isequal(expected_err_freq_list, return_err_list)
    disp('err_node_list.m function is working correctly')
else
    disp('err_node_list.m function not working correclty')
end

% Now let's test with an empty err_freq_list
expected_err_freq_list = [1; 1; 1; 0; 1]
return_err_list = err_node_list(num_nodes, incorrect_branch_mat, ...
    'empty')

if isequal(expected_err_freq_list, return_err_list)
    disp('err_node_list.m function is working correctly with empty list')
else
    disp('err_node_list.m function not working correclty with empty list')
end




