% Script to test x_nodes

% x_node_SDR test script;

% Test leaf node functionality
MI_test_mat = [ 0 10 8; 10 0 7; 8 7 0];
true_branch_data = [ 1 2; 2 3]
leaf_node_list = [1, 3];
expected_xSDR = 0.5*100;

x_SDR = @x_node_SDR;
xSDR = x_SDR(MI_test_mat, true_branch_data, 1);

if isequal(xSDR, expected_xSDR)
    disp('x_node_SDR fxn working correctly for leafs')
else disp('x node SDR fxn working incorrectly for leafs')
end

% Test for three branch connected nodes

true_branch_data = [1 2; 2 3; 3 4; 2 5];
MI_mat = [0 0 0 0 0; 7 0 0 0 0; 5 8 0 0 0; 6 5 8 0 0; 1 2 3 3 6];

% We expect 
expected_xSDR = 2/3*100;

x_SDR = @x_node_SDR;
xSDR = x_SDR(MI_mat, true_branch_data, 3)

if isequal(xSDR, expected_xSDR)
    disp('x_node_SDR fxn working correctly for 4-branch nodes')
else disp('x node SDR fxn working incorrectly for 4-branch nodes')
end


