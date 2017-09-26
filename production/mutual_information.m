function mutual_info_matrix = mutual_information(...
    single_node_entropy_vec, joint_entropy_matrix)

% mutual_info_matrix = mutual_information(...
%    single_node_entropy_vec, joint_entropy_matrix)
%
% The function takes in as input the single node entropy values H(j) and
% joint entropy matrix values, H(j,k). The output is a lower triangular
% matrix that contains the mutual information MI(j,k). Since
% mutual information is symmetric we only have to calculate the lower
% triangular values. 
%
% Inputs:
% ----- single_node_entropy_vec: This is a vector size (1 x number of
% buses) with values of the vector, v(i) equal to the entropy at node(i).
% The entropy is caluclated by approximating the data at a node in the
% input data matrix, node_volt_matrix(:,i), as a Gaussian distribution.
%    
% ----- joint_entropy_matrix: This matrix contains the joint entropy
% between two nodes. The matrix is a lower triangular matrix since the
% joint entropy is symmetric, i.e., Entropy(i,j) = Entropy(j,i). 
% The joint entropy of the same node, Entropy(i,j) is not used in the 
% chow-liu algorithm and therefore these values (the diagonal of 
% joint_entropy_matrix) are set to zero. % The entropy is caluclated by 
% approximating the data at a node in the input data matrix, 
% node_volt_matrix(:,i), as a Gaussian distribution. The size of the 
% matrix is (number of nodes x number of nodes). We use the
% equation joint_entropy([X,Y]) = k/2*(1+ln(2*pi)) + 1/2*ln|Sigma|. Where k
% is the dimension of the vector [X,Y] and Sigma is the covariance matrix.
%
% Outputs:
% ----- MI_matrix: This matrix is size (number of nodes x number of nodes).
% The matrix is lower triangular, meaning the diagonal and elements above
% the diagonal are zero since the mutual information between two nodes
% MI(i,j) = MI(j,i) is symmetric and the self-information MI(i,i) is not
% used in the algorithm since we don't connect a node to itself (to avoid
% cycles). The mutual information can be caluclated from the joint entropy
% and the single node entropy by recalling MI(i,j) = entropy(i) + 
% entropy(j) - joint_entropy(i,j). 


% Find the number of buses in the grid by looking at the joint entropy
% matrix size.
number_of_buses = numel(joint_entropy_matrix(1,:));
% intialize our mutual information matrix as a square matrix based
% on the number of buses in the grid.
mutual_info_matrix = zeros(number_of_buses,number_of_buses);

% Note we only populate the lower triangular values of the mutual
% information matrix since we don't care about self-information values and
% the mutual information is symmetric.
for i=1:number_of_buses
    for k=1:(i-1)
        % The mutual information can be caluclated from the joint entropy
        % and the single node entropy by recalling MI(i,j) = entropy(i) +
        % entropy(j) - joint_entropy(i,j).
        mutual_info_matrix(i,k) = single_node_entropy_vec(i)...
            +single_node_entropy_vec(k) - joint_entropy_matrix(i,k);
    end
end
end
