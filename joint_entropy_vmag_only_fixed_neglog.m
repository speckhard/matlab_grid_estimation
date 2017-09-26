% This function computes the joint entropy between pairs of nodes
function joint_entropy_matrix = ...
    joint_entropy_vmag_only_fixed_neglog(node_volt_matrix)

% this function takes in a 2d matrix of 
% (number of observations, number of buses). The output matrix is
% a lower triangular matrix since mutual information is symmetric, 
% I(1,2) = I(2,1).

% calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(node_volt_matrix(1,:));

% initialize the joint entropy matrix, note the size it determined
% by the number of buses in the grid.
joint_entropy_matrix = zeros(number_of_buses,number_of_buses);

for i=2:number_of_buses
    for k=1:(i-1)
            
        % here there is only two dimensions since vmag of both
        % nodes are considered.
        
            determinant_of_conode_volt_matrix = det(cov(node_volt_matrix(:,i) , ...
            node_volt_matrix(:,k))); 
        
        % let's check if the determinant value is very close to zero
        % but negative. If true, a numerical rounding error has likley
        % happened and we want to avoid getting a log of a negative number
        if (determinant_of_conode_volt_matrix <= 0) && ... 
                (determinant_of_conode_volt_matrix >  -0.0001) 
            % then we assume this is a numerical error and we make the
            % the mutual information negative by setting the joint entropy
            % value to a very large number
            joint_entropy_matrix(i,k) = -1E3;
        else % we 
            joint_entropy_matrix(i,k) = 2/2 ...
            *(1+log(2*pi))+0.5*log(determinant_of_conode_volt_matrix);
        end
    end
end