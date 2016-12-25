% The linearized parallle JVHW MI

% This function computes the joint entropy between pairs of nodes
function MI_matrix = find_JVHW_MI(Node_Volt_Matrix)
tic

MI_JVHW = @est_MI_JVHW;

% This function finds the MLE MI using scripts written by JVHW (Stanford'
% Weissman's Lab). THe maximum-liklihood MI is found. 

% This function performs the MI calls in a parellized fashion. 

% Input: Node_Volt_Matrix - 2d matrix with size (time of observation, node
% number) and values of voltgnitude taken at time (row) and node (column). 

% Input: diagonal_flag. In cases where we want to plot the MI heatmap we
% need to calculate the diagonals of the mutual information (MI) matrix.
% For regular estimation we don't require the diagonals since the graph we
% estimtae is an acylical graph, a dependance tree. 

% Ouput: Using the JVHW MLE MI script est_MI_MLE.m we can find the maximum
% liklihood mutual information. The output MI matrix has size (number of
% nodes, number of nodes). Only the lower triangular portion of the matrix
% is computed since MI is symmetric.

number_of_buses = numel(Node_Volt_Matrix(1,:));


% Initialize the Mutual information matrix, note the size is determined
% by the number of buses in the grid.
MI_matrix_lin = zeros(number_of_buses*number_of_buses,1);
MI_matrix_non_lin = zeros(number_of_buses, number_of_buses);
% Let's linearize the indices
iterations = size(MI_matrix_non_lin);
loop_end = prod(iterations) - number_of_buses;

% We run through one linearized for loop to
parfor j = 1:loop_end
    [i,k] = ind2sub(iterations, j);  
    if i > k
        MI_matrix_lin(j) = MI_JVHW(Node_Volt_Matrix(:,i),...
            Node_Volt_Matrix(:,k));
    end
end

MI_matrix = reshape(MI_matrix_lin, iterations);
disp('time to find the lin par JVHW MI')
toc