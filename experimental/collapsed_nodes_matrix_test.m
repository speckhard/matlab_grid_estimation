% Collapsed_node_matrix Test
% Colomn2 = Column1 + 0.1;
test_matrix = [1 1 3 4 3 3; 2 2 4 5 4 4];

% Nodes 1,2 are the same. Nodes 3,5,6 are the same

% When we don't use the MI matrix, and use threshold 0.2,
% we expect 1,2 to be on the list.
expected_collapsed_nodes_matrix = [1,1,2,0,0,0,0;...
    ;0,2,0,0,0,0,0;...
    2,3,5,6,0,0,0;
    0,4,0,0,0,0,0;
    0,5,0,0,0,0,0;
    0,6,0,0,0,0,0];

find_collapsed_matrix = @collapsed_nodes_matrix;
collapsed_nodes_mat = find_collapsed_matrix(test_matrix)

if isequal(collapsed_nodes_mat, expected_collapsed_nodes_matrix )
    disp('collapse_nodes_matrix function performing as expected')
else
    disp('collapse_nodes_matrix function performing incorrectly')
end
    