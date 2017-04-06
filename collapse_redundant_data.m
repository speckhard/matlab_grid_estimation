function [node_volt_matrix, true_branches] ...
    = collapse_redundant_data(node_volt_matrix, true_branches);

% [node_volt_matrix, true_branches] ...
%    = collapse_redundant_data(node_volt_matrix, true_branches);
%
% This function will check to see if there are any nodes that contain
% voltage measurements that are the same as another node. For instance, if
% 40 nodes are given, this function will check if Node 1 has the same data
% as Node 2. If Node Node 1 and Node 2 have the same data this function
% will collapse the two nodes, meaning it will remove Node 2 and fix the
% list of true branches to replace any reference to Node 2 with Node 1.
%
% Inputs:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
%
% ----- true_branches: This is a matrix containing the true branches in
% the system. The number of rows in this matrix corresponds to the number
% of true branches in the system. THe number of columns should be equal to
% two, which is the number of nodes involved in a single branch.
%
% Output: 
% ----- node_volt_matrix: This matrix is the node_volt_matrix dataset with 
% the redundant nodes removed. Therefore, the output matrix will be 
% different size than the input matrix if redundant nodes are present in
% the input matrix. Redundant referes to a node that has all the same
% data values as another node. The node which is lower in number is
% retained when a redundant node is found. Ex. If Node 34 has the same data
% as Node 1. Node 34 will be removed from node volt matrix.

% ----- true_branches: The list of true branches is also an output, it has 
% redundant nodes replaced with lower node label number non-redundant 
% nodes. Ex. Imagine Node 34 has the same data as Node 1. Any branches in
% the true_branches matrix containing node 34, let's say a branch (7,34).
% The output true_branches will now list (7,1). If there's a branch from
% (1,34) it will have to be deleted since a branch (1,1) is a 
% self-referring branch. Self-referring branches are sometimes returned by
% this function. Remove_redundant_branches.m removes self-referring 
% branches and should be called after this function. Therefore
% the true_branches variable should have the same size before and after
% this function call since no branches are removed.

tic % For timing performance.
% Let's find the number of observations in the dataset. This variable is
% the number of measurements performed on a node contained in the dataset
% node_volt_matrix. 
number_observations = numel(node_volt_matrix(:,1));

% We initialize a variable for the number of identical nodes found. This is
% useful for debugging purposes.
number_identical_nodes = 0;

% We will cycle through the node_volt_matrix and see if we can find
% redundant nodes. If so we will delete this node. Note the number of     
% columns (i.e. nodes) is changing, this means we need to
% evaluate this number every loop of the cycle.

% We have to use a while loop since in Matlab for loops evaluate bounds at
% first run and we will change the size of our matrix that we iterate
% through, since we find identical pairs, we'll remove columns. 
outer_loop_index = 1;

matrix_of_identical_nodes = zeros(numel(true_branches(:,1)), ...
    numel(true_branches(1,:)));

deleted_node_numbers = [];

while outer_loop_index < numel(node_volt_matrix(1,:))
    % We don't want to evaluate whether one node is the same as another
    % column so we check starting with node i+1.
    % Re-intialize k.
    inner_loop_index = outer_loop_index + 1; 
    while inner_loop_index <= numel(node_volt_matrix(1,:))
        
        % Check whether it is the same node.
        if (sum(node_volt_matrix(:,outer_loop_index) ...
                == node_volt_matrix(:,inner_loop_index)) ...
                == number_observations)
            % This means we have found two nodes that have identical data
            % for all measurements.
            number_identical_nodes = number_identical_nodes + 1;
            
            % The below code is used for de-bugging.
%             matrix_of_identical_nodes(number_identical_nodes, :) = ...
%                 [outer_loop_index,inner_loop_index];
            % Now let's remove the identical nodes.
            
            % Deleted nodes matrix grwos by one.
            %deleted_nodes = deleted_nodes + 1;
            node_volt_matrix(:,inner_loop_index) = [];
            
            % Update the list of true branches.
            % Go through the rows of the true branch data set.
            for g = 1:numel(true_branches(:,1))
                % Check if we find the second identical node-k in the row.
                for h = 1:numel(true_branches(1,:))
                    if true_branches(g,h) == inner_loop_index
                        true_branches(g,h) = outer_loop_index;
                    elseif true_branches(g,h) > inner_loop_index
                    % Since I've just deleted a col, I also need to
                    % downshift all the values in the True Branch Data set 
                    % that were above this col. Ex. if i delete column 5 
                    % (node 5), i need to make nodes 6 appear as node 5 in 
                    % the true branch data.
                        true_branches(g,h) = true_branches(g,h) -1;
                    end
                end
            end
        else
        % If a column was not deleted continue iterating. We don't 
        % increment iterator if a col was deleted since now col k is a 
        % different col.
            inner_loop_index = inner_loop_index +1;
        end
    end
    outer_loop_index = outer_loop_index + 1;
end
disp('the number of redundant nodes is')
disp(number_identical_nodes)
disp('time to remove redundant nodes')
toc
end
