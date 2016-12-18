function leaf_node_list = find_leaf_nodes(true_branch_list)

% This function takes the list of true branches (2D list, rows contain two 
% nodes, one in each column, and each row is a new branch) in a tree graph 
% and returns the nodes which are only connected to one other node in a 
% 1D list. 

% Inputs:
% - true_branch_list, is the list of pairs of nodes which are connected in
% the true graph of the smart grid. There are (number of nodes - 1) rows. 
% (number of nodes - 1) is the total number of branches in an acylic graph
% (dependence tree) which is the approximation used to model the smart
% grid.

% Outputs:
% - leaf_node_list, is a list of node numbers corresponding to nodes which
% are connected to only one branch in the true graph. 


leaf_counter = 1; % Counter to keep track of number of leaf nodes.
num_branches = numel(true_branch_list(:,1)); 
leaf_node_list = zeros(1,num_branches+1); 

% For a tree there are x number of branches. There are x+1 number of nodes.
% We cycle through every integer node from 1 to x+1.
for i = 1:(num_branches+1)
    k = find(true_branch_list == i);
    if numel(k) ==1 % Then i is a leaf
        leaf_node_list(leaf_counter) = i;
        leaf_counter = leaf_counter + 1; 
    end
end

% Remove the useless zero values at the end of the leaf node list
leaf_node_list = leaf_node_list(1:leaf_counter-1);
        
        
