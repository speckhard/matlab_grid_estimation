function success_counter = leaf_node_SDR(...
    mutual_information_mat, leaf_node_list, true_branch_data)

% Function to compute whether the leaf node is predicted correctly
% connected based on MI to the other leafs. ]

% Inputs: mutual_information_mat - this is the matrix of of mutual
% information, it should be a lower triangular matrix with diagonal values
% equal to zero.

% Check if the mutual_information_mat diag values are zero.
num_nodes = numel(mutual_information_mat(:,1));
diag_MI_vals = diag(mutual_information_mat);
success_counter = 0;
if diag_MI_vals ~= zeros(num_nodes, 1)
    error('the mutual information matrix has non-zero diagonal values')
end

% Cycle through each node in the leaf_node_list.
for i = 1:numel(leaf_node_list)
    leaf_node = leaf_node_list(i);
    % Find the largest MI pair with the leaf_node.
    MI_col_of_leaf = mutual_information_mat(:,leaf_node);
    [max_MI, partner_node] = max(MI_col_of_leaf);
    % Check if the largest MI pair is a true edge.
    MI_edge = [leaf_node, partner_node];
    [correct_single_edge_counter, SDR] = findSDR(MI_edge, ...
        true_branch_data);
    
    if correct_single_edge_counter == 1
        success_counter = success_counter +1;
    end
end

    
    
    
    