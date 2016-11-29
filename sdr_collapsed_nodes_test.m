% sdr_collapsed_nodes test

test_matrix = [1 1 3 4 3 3; 2 2 4 5 4 4];
expected_collapsed_nodes_matrix = [1,1,2,0,0,0,0;...
    ;0,2,0,0,0,0,0;...
    2,3,5,6,0,0,0;
    0,4,0,0,0,0,0;
    0,5,0,0,0,0,0;
    0,6,0,0,0,0,0]

expected_collapsed_nodes_list = [1,2;3,5;5,6];
2
find_sdr_collapsed_nodes = @sdr_collapsed_nodes;
sdr = find_sdr_collapsed_nodes(expected_collapsed_nodes_matrix,...
    expected_collapsed_nodes_list);

if isequal(sdr, 1)
    disp('sdr_collapsed_nodes is working correctly')
else
    disp('sdr_collapsed_nodes is not working correctly')
end
