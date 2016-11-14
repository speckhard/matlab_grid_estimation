% This function computes the joint entropy between pairs of nodes
function MI_matrix = find_JVHW_MI(Node_Volt_Matrix,diagonal_flag)
tic

MI_JVHW = @est_MI_JVHW;
% this function takes in a 3d matrix of dimenstional array (real/imaginary, 
% bus number, observation number) of size 
% (number of observations, 2, number of buses). The output matrix is
% a lower triangular matrix since mutual information is symmetric, 
% I(1,2) = I(2,1).

% calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(Node_Volt_Matrix(1,:));


% initialize the joint entropy matrix, note the size it determined
% by the number of buses in the grid.
MI_matrix = zeros(number_of_buses,number_of_buses);

if strcmp(diagonal_flag,'diagonals')
    loop_endpoint = 0
else
    loop_endpoint = 1;
end

for i=1:number_of_buses
    for k=1:(i-loop_endpoint)
%         if k == i % we don't care about h(1,1) since we don't use it
%             in mutual information calculations
%             joint_entropy_matrix(k,i) = 0;
        %else 
            % squeeze is used here to ensure v_clean_matrix is taken
            % as a column vector and not as a three dimensional matrix
            % of size (1,1,number of observations).
            MI_matrix(i,k) = MI_JVHW(Node_Volt_Matrix(:,i),...
                Node_Volt_Matrix(:,k));
        
    end
end
disp('time to find the JVHW MI')
toc