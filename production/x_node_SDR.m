function x_SDR = x_node_SDR(MI_mat...
    , true_branches, branch_num)

% x_SDR = x_node_SDR(MI_mat, true_branches, branch_num)
%
% This function computes the succesful rate of detecting branches connected
% to nodes which are connected to integer x different branches in a acyclic
% graph, dependence tree approximating a smart grid. 
%
% Input: 
% ----- MI_matrix: This matrix is size (number of nodes x number of nodes).
% The matrix is lower triangular, meaning the diagonal and elements above
% the diagonal are zero since the mutual information between two nodes
% MI(i,j) = MI(j,i) is symmetric and the self-information MI(i,i) is not
% used in the algorithm since we don't connect a node to itself (to avoid
% cycles).
%
% ----- true_branches: This is a matrix containing the true branches in
% the system. The number of rows in this matrix corresponds to the number
% of true branches in the system. THe number of columns should be equal to
% two, which is the number of nodes involved in a single branch.
%
% ----- branch_num: This integer specifies why type of SDR we are looking
% for. If branch_num is equal to 1, then we're are looking at all the leaf
% nodes that have only one branch in true topology. Setting branch_num
% equal to 1 will have as an effect that this function finds the percentage
% of bracnhes containing one leaf node that are correctly connected by the
% algorithm. If we set the branch num to be 2 or 3, then we will find the
% SDR for nodes with 2-3 branches respectively. 

% Output: 
% ----- x_SDR: This is the percent of branches connected to integer 
% branch_num other nodes that have been correctly identified by the
%a lglorithm.

% First let's ensure diagonals of MI_mat are zero. 
num_nodes = numel(MI_mat(:,1));
diag_MI_vals = diag(MI_mat);
if diag_MI_vals ~= zeros(num_nodes, 1)
    error('the mutual information matrix has non-zero diagonal values')
end
% Now let's reflect the MI mat. This will give us a symmetric MI matrix
% where diagonal values are zero.
reflect_MI_mat = @reflect_lower_triang_mat;
MI_mat = reflect_MI_mat(MI_mat);

% This is a counter to be used to keep track of the number of correctly
% identified branches.
success_counter = 0;

% Now let's find the x_nodes
find_xnodes = @find_x_nodes;
find_sdr = @find_SDR;
x_node_list = find_xnodes(true_branches,branch_num);

% Cycle through each node in the x_node_list.
for i = 1:numel(x_node_list)
    x_node = x_node_list(i);
    %disp('x node') % Used for debugging.
    %disp(x_node)
    MI_col_of_x = MI_mat(:,x_node);
    [sorted_MI_col, sort_indices] = sort(MI_col_of_x, 'descend');
    % branch_num tells how many branches were examining with an x_node
    for j = 1:branch_num
        % Find the largest MI pair with the x_node.  
        partner_node = sort_indices(j);
        % Check if the largest MI pair is a true edge.
        MI_edge = [x_node, partner_node];
        [correct_single_edge_counter, SDR] = find_sdr(MI_edge, ...
            true_branches);        
        if correct_single_edge_counter == 1
            success_counter = success_counter +1;
        end
    end
end

% Find SDR percent of x_nodes
x_SDR = success_counter/(branch_num)/(numel(x_node_list))*100;
end


