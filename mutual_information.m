% This function computes the mutual information

function mutual_info_matrix = mutual_information(...
    single_node_entropy_vec, joint_entropy_matrix)

% the matrix takes in as input the single node entropy values H(j) and
% joint entropy matrix values, H(j,k). The output is a lower triangular
% matrix that contains the mutual information I(j,k). Since
% mutual information is symmetric we only have to calculate the lower
% triangular values. 

% Find the number of buses in the grid by looking at the joint entropy
% matrix size.
number_of_buses = numel(joint_entropy_matrix(1,:));
% intialize our mutual information matrix as a square matrix based
% on the number of buses in the grid.
mutual_info_matrix = zeros(number_of_buses,number_of_buses);

for i=1:number_of_buses
    for k=1:(i-1)
%         if i == k % this is the self-information
%             mutual_info_matrix(i,k) = 0;
%         else
            mutual_info_matrix(i,k) = single_node_entropy_vec(i)...
                +single_node_entropy_vec(k) - joint_entropy_matrix(i,k);
       % end
    end
end