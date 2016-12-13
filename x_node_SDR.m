function x_SDR = x_node_SDR(MI_mat...
    , true_branch_data, branch_num)

% This function computes the succesful rate of detecting branches connected
% to nodes which are connected to integer x different branches in a acyclic
% graph, dependence tree approximating a smart grid. 

% Input: MI_mat, is a lower traingular mutual information matrix. It has
% size [number of nodes x number of nodes]. The diagonal values are zero
% since the graph is forced to be a cyclic in the smart grid approximation.
%
% x_node_list, is the list of nodes which has integer x different branches.
% 
% true_branch_data, is the true list of branches. 

% Output: SDR_percent is the percent of correctly placed nodes in the  

% First let's ensure diagonals of MI_mat are zero. 
num_nodes = numel(MI_mat(:,1));
diag_MI_vals = diag(MI_mat);
success_counter = 0;
if diag_MI_vals ~= zeros(num_nodes, 1)
    error('the mutual information matrix has non-zero diagonal values')
end
% Now let's reflect the MI mat
reflect_MI_mat = @reflect_lower_triang_mat;
MI_mat = reflect_MI_mat(MI_mat);

% Now let's find the x_nodes
find_xnodes = @find_x_nodes;
x_node_list = find_xnodes(true_branch_data,branch_num);

% Cycle through each node in the x_node_list.
for i = 1:numel(x_node_list)
    x_node = x_node_list(i);
    
    MI_col_of_x = MI_mat(:,x_node);
    [sorted_MI_col, sort_indices] = sort(MI_col_of_x, 'descend');
    % branch_num tells how many branches were examining with an x_node
    for j = 1:branch_num
        % Find the largest MI pair with the x_node.  
        partner_node = sort_indices(j);
        % Check if the largest MI pair is a true edge.
        MI_edge = [x_node, partner_node];
        [correct_single_edge_counter, SDR] = findSDR(MI_edge, ...
            true_branch_data);        
        if correct_single_edge_counter == 1
            success_counter = success_counter +1;
        end
    end
end

% Find SDR percent of x_nodes
x_SDR = success_counter/(branch_num)/(numel(x_node_list))*100;

