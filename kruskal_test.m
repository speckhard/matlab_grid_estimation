% Test for the Kruskal.m matlab function

test_matrix = [0 2 6 1; 2 0 4 3; 6 4 0 4; 1 3 4 0]
expected_mat_connectivity = [0 0 6 0; 0 0 4 0 ; 6 4 0 4; 0 0 4 0];
kruskal_algorithim = @kruskal
mat_connectivity = kruskal_algorithim(test_matrix);


plot(graph(mat_connectivity))

if isequal(mat_connectivity, expected_mat_connectivity)
    disp(['kruskal function performing as expected', ...
    ' on voltage measurement data'])
else
    disp(['kruskal function performs incorrectly', ...
    ' on voltage measurement data'])
end
