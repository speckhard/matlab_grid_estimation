% This function computes the joint entropy between pairs of nodes
function joint_entropy_matrix = ...
    joint_entropy_vmag_only(node_volt_matrix)

% joint_entropy_matrix = ...
%    joint_entropy_vmag_only(node_volt_matrix)
%
% This function calculates the pair-wise mutual information between two
% nodes in the input data matrix, node_volt_matrix. The mutual information
% is claculated by appoximating the distribution of data at each node as a
% Gaussian distribution. 
%
% Input:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
%
% Ouput:
% ----- joint_entropy_matrix: This matrix contains the joint entropy
% between two nodes from the input matrix, node_volt_matrix. The 
% matrix is a lower triangular matrix since the joint entropy is
% symmetric, i.e., Entropy(i,j) = Entropy(j,i). The joint entropy of the
% same node, Entropy(i,j) is not used in the chow-liu algorithm and
% therefore these values (the diagonal of joint_entropy_matrix) are set to
% zero. % The entropy is caluclated by approximating the data at a node in
% the input data matrix, node_volt_matrix(:,i), as a Gaussian distribution.
% The size of the matrix is (number of nodes x number of nodes). We use the
% equation joint_entropy([X,Y]) = k/2*(1+ln(2*pi)) + 1/2*ln|Sigma|. Where k
% is the dimension of the vector [X,Y] and Sigma is the covariance matrix.

% Calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(node_volt_matrix(1,:));

% Initialize the joint entropy matrix, note the size it determined
% by the number of buses in the grid.
joint_entropy_matrix = zeros(number_of_buses,number_of_buses);

% We avoid calculating the joint_entropy values using the same node twice.
% Therefore the diagonal values for the join_entropy_matrix are not
% calculated.
for i=2:number_of_buses
    for k=1:(i-1)
        
        % We use the equation joint_entropy([X,Y]) = k/2*(1+ln(2*pi)) +
        % 1/2*ln|Sigma|. Where k is the dimension of the vector [X,Y] and 
        % |Sigma| is the deteriminant of the covariance matrix. For two 
        % nodes, where each node contributes it's voltage magntiude data, 
        % k, the dimension of [X,Y] is equal to two.
        
        determinant_of_cov_matrix = det(cov(node_volt_matrix(:,i) , ...
            node_volt_matrix(:,k)));
        
        % Let's check if the determinant value is very close to zero
        % and negative. If this is true, a numerical rounding error has 
        % likley happened and we want to avoid getting a log of a negative
        % number.
        if (determinant_of_cov_matrix <= 0) && ...
                (determinant_of_cov_matrix >  -0.0001)
            % Then we assume this is a numerical error and we make the
            % mutual information negative by setting the joint entropy
            % value to a very negative number. This is abritrary and this
            % case should never occur in practice unless we end up
            % computing the joint entropy of two nodes that are labelled
            % differently but contain the same data.
            joint_entropy_matrix(i,k) = -1E3;
        else % Othewrwise we compute as normal.
            joint_entropy_matrix(i,k) = 2/2 ...
                *(1+log(2*pi))+0.5*log(determinant_of_cov_matrix);
        end
    end
end
end