function MI_matrix = find_JVHW_MI(Node_Volt_Matrix,diagonal_flag)
tic

MI_MLE = @est_MI_MLE;

% This function finds the MLE MI using scripts written by JVHW (Stanford'
% Weissman's Lab). THe maximum-liklihood MI is found. 

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


% Initialize the MI matrix, note the size it determined
% by the number of buses in the grid.
MI_matrix = zeros(number_of_buses,number_of_buses);

if strcmp(diagonal_flag,'diagonals')
    loop_endpoint = 0;
else
    loop_endpoint = 1;
end

for i=1:number_of_buses
    for k=1:(i-loop_endpoint)
            MI_matrix(i,k) = MI_MLE(Node_Volt_Matrix(:,i),...
                Node_Volt_Matrix(:,k));
        
    end
end
disp('time to find the MLE MI')
toc