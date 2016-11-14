function [Node_Volt_Matrix, True_Branch_Data] ...
    = collapse_redundant_data(Node_Volt_Matrix, True_Branch_Data);
tic
% This function will check to see if there are any nodes that contain
% voltage measurements that are the same as another node. For instance, if
% 40 nodes are given, this function will check if Node 1 has the same data
% as Node 2. If Node Node 1 and Node 2 have the same data this function
% will collapse the two nodes, meaning it will remove Node 2 and fix the
% list of true branches to replace any reference to Node 2 with Node 1.

% The input variable Node_Volt_Matrix is a matrix of size (number of
% observations, number of nodes), where each row is a series of
% measurements taken at a certain time, and each column is a different
% node.

% The input variable True_Branch_Data is a matrix of size (number of
% branches in the true tree, 2 (each brain is a pair of nodes)).

% The output of the function is the Node_Volt_Matrix dataset (voltage
% measruments of different nodes at different times) with the redundant
% nodes removed. Redundant here means a node that has all the same
% measurement data as another node. The node which is lower in number is
% retained when a redundant node is found. The list of true branches is
% also an output, it has redundant nodes replaced with lower value
% non-redundant nodes. Note, the fixed true branches data can have
% self-referring pairs. Ex. If Node 34 has the same data as Node 1. Node 34
% will be removed from Node Volt Matrix. If a branch had existed from Node
% 1 to Node 34, it will now list [1, 1] instead of the [1,34] previously.
% Post-processing will be necessesary to remove these self-referring nodes.

% Let's find the number of observations in the dataset. This variable is
% the number of measurements performed on the node contained in the dataset
% Node_Volt_Matrix. 
number_observations = numel(Node_Volt_Matrix(:,1));

% We initialize a variable for the number of identical nodes found. This is
% useful for debugging purposes.
number_identical_nodes = 0;

% We will cycle through the Node_Volt_Matrix and see if we can find
% redundant nodes. If so we will delete this node. Note the number of     
% columns (i.e. nodes) is changing, this means we need to
% evaluate this number every loop of the cycle.

% we have to use a while loop since in Matlab for loops evaluate bounds at
% first run and we will change the size of our matrix that we iterate
% through, since we find identical pairs, we'll remove columns. 
outer_loop_index = 1;

matrix_of_identical_nodes = zeros(numel(True_Branch_Data(:,1)), ...
    numel(True_Branch_Data(1,:)));

while outer_loop_index < numel(Node_Volt_Matrix(1,:))
    % we dont want to evaluate whether one node is the same as another
    % column so we check starting with node i+1
    % re-intialize k
    inner_loop_index = outer_loop_index + 1; 
    while inner_loop_index <= numel(Node_Volt_Matrix(1,:))
        
        % check whether it is the same node
        if (sum(Node_Volt_Matrix(:,outer_loop_index) ...
                == Node_Volt_Matrix(:,inner_loop_index)) ...
                == number_observations)
            
            number_identical_nodes = number_identical_nodes + 1;
            matrix_of_identical_nodes(number_identical_nodes, :) = ...
                [outer_loop_index,inner_loop_index];
            % now let's remove the identical node
            %Node_Volt_Matrix(:,k) = ones(number_observations,1)*k;
            Node_Volt_Matrix(:,inner_loop_index) = [];
            
            % change the list of true branches
            % Go through the rows of the true branch data set
            for g = 1:numel(True_Branch_Data(:,1))
                % check if we find the second identical node-k in the row
                for h = 1:numel(True_Branch_Data(1,:))
                    if True_Branch_Data(g,h) == inner_loop_index
                        True_Branch_Data(g,h) = outer_loop_index;
                    elseif True_Branch_Data(g,h) > inner_loop_index
                    % since I've just deleted a col, I also need to
                    % downshift all the values in the True Branch Data set 
                    % that were above this col. Ex. if i delete column 5 
                    % (node 5), i need to make nodes 6 appear as node 5 in 
                    % the true branch data
                        True_Branch_Data(g,h) = True_Branch_Data(g,h) -1;
                    end
                end
            end
        %end
        else
        % if a column was not deleted continue iterating. We dont increment
        % iterator if a col was deleted since now col k is a different col
            inner_loop_index = inner_loop_index +1;
        end
    end
    outer_loop_index = outer_loop_index + 1;
end
disp('the number of redundant nodes is')
disp(number_identical_nodes)
disp('time to remove redundant nodes')
toc
