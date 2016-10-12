% This function selects the maximum weight spanning tree
% we select the set of nodes with the maximum mutual information
% so long as adding a set of nodes does not create a cycle in our 
% undirected graph.

function valid_branches = find_branches(sorted_MI_nodes, ...
    number_of_buses)


% recall number of max connections is the number of buses - 1 
% since we are looking for a tree graph, i.e. 2nd order prob fxn
valid_branches = zeros(number_of_buses - 1,2);

% the first sorted pair of nodes is our starting point
valid_branches(1,:) = sorted_MI_nodes(1,:);
valid_branches_count = 1;

cc = @cycle_check;

% the first branch is taken to be the one with largest MI and
% subsequent branches are determined in this for loop.
for i = 2:numel(sorted_MI_nodes)
    start_flag = 1;
    
    if cc(sorted_MI_nodes(i,1),...
        sorted_MI_nodes(i,2), start_flag, ...
        valid_branches,[1,1]) == 0
        
        valid_branches_count = valid_branches_count + 1; %print for debug
        valid_branches(valid_branches_count,:) = ...
            sorted_MI_nodes(i,:);
    end
    
    if valid_branches_count == number_of_buses - 1
        break
    end
end