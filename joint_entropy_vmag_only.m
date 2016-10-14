% This function computes the joint entropy between pairs of nodes
function joint_entropy_matrix = joint_entropy(v_matrix)

% this function takes in a 2d matrix of 
% (number of observations, number of buses). The output matrix is
% a lower triangular matrix since mutual information is symmetric, 
% I(1,2) = I(2,1).

% calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(v_matrix(1,:));

% initialize the joint entropy matrix, note the size it determined
% by the number of buses in the grid.
joint_entropy_matrix = zeros(number_of_buses,number_of_buses);

for i=2:number_of_buses
    for k=1:(i-1)
            
        % here there is only two dimensions since vmag of both
        % nodes are considered.
        
            joint_entropy_matrix(i,k) = 2/2 ...
            *(1+log(2*pi))+0.5* ...
            log(det(cov(v_matrix(:,i) , ...
            v_matrix(:,k))));        
        
        end
    end
end