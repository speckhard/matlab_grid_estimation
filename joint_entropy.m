% This function computes the joint entropy between pairs of nodes
function joint_entropy_matrix = joint_entropy(v_clean_matrix)

% this function takes in a 3d matrix of dimenstional array (real/imaginary, 
% bus number, observation number) of size 
% (number of observations, 2, number of buses). The output matrix is
% a lower triangular matrix since mutual information is symmetric, 
% I(1,2) = I(2,1).

% calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(v_clean_matrix(1,1,:));
% calculate the number of observations (used in below loop)
number_of_observations = numel(v_clean_matrix(:,1,1));

% initialize the joint entropy matrix, note the size it determined
% by the number of buses in the grid.
joint_entropy_matrix = zeros(number_of_buses,number_of_buses);

for i=1:number_of_buses
    for k=1:(i-1)
%         if k == i % we don't care about h(1,1) since we don't use it
%             in mutual information calculations
%             joint_entropy_matrix(k,i) = 0;
        %else 
            % squeeze is used here to ensure v_clean_matrix is taken
            % as a column vector and not as a three dimensional matrix
            % of size (1,1,number of observations).
            joint_entropy_matrix(i,k) = 4/2 ...
            *(1+2*log(2*pi))+0.5* ...
            log(det(cov([squeeze(v_clean_matrix(:,1,i)), ...
                squeeze(v_clean_matrix(:,1,k))])));
        end
    end
end