% leaf_node_SDR test script;

MI_test_mat = [ 0 10 8; 10 0 7; 8 7 0];
true_branch_data = [ 1 2; 2 3]
leaf_node_list = [1, 3];
expected_success_counter = 1;

leaf_SDR = @leaf_node_SDR;
sucess_counter = leaf_SDR(MI_test_mat, leaf_node_list, true_branch_data)

if isequal(sucess_counter, expected_success_counter)
    disp('leaf_node_SDR fxn working correctly')
else disp('leaf node SDR fxn working incorrectly')
end

