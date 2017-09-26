function single_node_entropy_vec = ...
    single_node_entropy_vmag_only(node_volt_matrix)

% This function calculates the entropy of the voltage magnitude data 
% at each node.
%
% single_node_entropy_vec = ...
%    single_node_entropy_vmag_only(node_volt_matrix)
%
% Input: 
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
%
% Output:
% ----- single_node_entropy_vec: This is a vector size (1 x number of
% buses) with values of the vector, v(i) equal to the entropy at node(i).
% The entropy is caluclated by approximating the data at a node in the
% input data matrix, node_volt_matrix(:,i), as a Gaussian distribution.

% Calculate the number of buses (this is used in the for loop below).
number_of_buses = numel(node_volt_matrix(1,:));

% Initialize the entropy vector for which values will be calculated.
single_node_entropy_vec = zeros(1,number_of_buses); 

for i=1:number_of_buses
    % We use the equation H(X) = k/2*(1+ln(2*pi)) + 1/2*ln|Sigma|. Where k
    % is the dimension of the vector X and Sigma is the covariance matrix.
    % Note, here we only have one dimension, vmag(i), in our entropy calc.
    % This is not the case if we would like to include phase information
    % into our calculation.
    single_node_entropy_vec(i) = 1/2 * ...
        (1+log(2*pi)) + 0.5*log(det(cov( ... 
        node_volt_matrix(:,i))));
end
end
