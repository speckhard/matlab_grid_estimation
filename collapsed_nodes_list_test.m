% Collapsed Nodes List Test

% Colomn2 = Column1 + 0.1;
test_matrix = [1 1.1 3; 2 2.1 4];

%MI(2,1) = 1, MI(3,1) = 2, MI(3,2) = 3;
mutual_information_matrix = [0 0 0; 3 0 0; 2 5 0];

% When we don't use the MI matrix, and use threshold 0.2,
% we expect 1,2 to be on the list.
expected_collapsed_node_list = [1,2;0,0;0,0];

% When we use the MI matrix, with threshold 3.5, we expect [2,3] on the
% list.
expected_MI_collapsed_node_list = [2,3;0,0;0,0];

find_collapsed_list = @collapsed_nodes_list;
collapsed_node_list = collapsed_nodes_list(test_matrix, 'no MI', 0.2)

if isequal(collapsed_node_list, expected_collapsed_node_list )
    disp(['collapse_nodes_list function performing as expected', ...
    ' with no MI use'])
else
    disp(['collapse_nodes_list function performing incorrectly', ...
    ' with no MI use'])
end

collapsed_node_list = collapsed_nodes_list(test_matrix, ...
    mutual_information_matrix, 3.5);

if isequal(collapsed_node_list,expected_MI_collapsed_node_list)
    disp(['collapse_nodes_list function performing as expected', ...
    ' with MI use'])
else
    disp(['collapse_nodes_list function performing incorrectly', ...
    ' with MI use'])
end
    