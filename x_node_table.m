% Script to calculate the a matrix serving as a table, to tell the user how
% many leaf nodes, 2 branch connected nodes, 3 .... etc, in the true graph.

% Store results of x nodes in a matrix, first item corresponds to leaf
% nodes, 2nd iten to nodes with 2 branches, etc...
node_type_mat = zeros(10,1);

% First, copy the data minus the feeder bus
node_volt_matrix = SG2datavolt60min;
% Second, copy the list of true branches.
true_branch_data = Truebranchlist;%SandiaNationalLabTrueNodeData(1:51,:);

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 


find_nodes = @find_x_nodes;
temp_counter = 0;
for i = 1:3
    temp = find_nodes(true_branch_data,i);
    node_type_mat(i) = numel(temp);
    if numel(temp) ~= 0
        temp_counter = temp_counter + 1;
    end
end

node_type_mat = node_type_mat(1:temp_counter)
