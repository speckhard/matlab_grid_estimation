function x_node_list = find_x_nodes(true_branch_list,...
    connected_num_nodes);

% This function takes the list of true branches (2D list, rows contain two 
% nodes, one in each column, and each row is a new branch) in a tree graph 
% and returns the nodes which are connected to a fixed number of nodes
% specified in connected_num_of_nodes.

% Inputs:
% - true_branch_list, is the list of pairs of nodes which are connected in
% the true graph of the smart grid. There are (number of nodes - 1) rows. 
% (number of nodes - 1) is the total number of branches in an acylic graph
% (dependence tree) which is the approximation used to model the smart
% grid.
% - connceted_num_of_nodes, is an integer number of nodes. If we are
% looking for nodes connected to one other node in the true graph, we set
% connected_num_of_nodes. If we are looking for nodes which are connected
% to integer x other nodes, we set connected_num_of_nodes to integer x. 

% Outputs:
% - x_node_list, is a list of node numbers corresponding to nodes which
% are connected with connected_num_of_nodes branches in the true graph.

% Ensure connected_num_of_nodes is an integer
if isequal(floor(connected_num_nodes), connected_num_nodes) ~= 1 
    error(['This fxn searches for nodes connected with an integer',...
        'number of branches, please input an integer of branches'])
end

% Ensure true branch list has two columns
if numel(true_branch_list(1,:)) ~=2
    error(['The true branch list is formatted incorrectly, it must be',...
        'a matrix size ((number of nodes -1), 2).'])
end

x_counter = 1; % Counter to keep track of number of leaf nodes.
num_branches = numel(true_branch_list(:,1)); 
x_node_list = zeros(1,num_branches+1); 

% For a tree there are x number of branches. There are x+1 number of nodes.
% We cycle through every integer node number from 1 to x+1.
for i = 1:(num_branches+1)
    k = find(true_branch_list == i);
    % If there are connected_num_of_nodes appearances of leaf i in the true
    % branch list, then node i is connected with the desired number of
    % branches. 
    if numel(k) ==  connected_num_nodes
        x_node_list(x_counter) = i;
        x_counter = x_counter + 1; 
    end
end

% Remove the useless zero values at the end of the leaf node list
x_node_list = x_node_list(1:x_counter-1);

end


    


