function weighted_matrix_of_connectivity = kruskal(MI_matrix)

% weighted_matrix_of_connectivity = kruskal(MI_matrix)
% 
% This function performs find the maximum spanning tree based on pair-wise
% mutual information values stored in the input matrix, MI_matrix. The
% function returns a matrix of connectivity, 
% weighted_matrix_of_connectivity. Note the algorithm implemented here uses
% path compression to speed up performance.
%
% Input:
% ----- MI_matrix: This matrix is size (number of nodes x number of nodes).
% The matrix is lower triangular, meaning the diagonal and elements above
% the diagonal are zero since the mutual information between two nodes
% MI(i,j) = MI(j,i) is symmetric and the self-information MI(i,i) is not
% used in the algorithm since we don't connect a node to itself (to avoid
% cycles).
%
% Ouput:
% ----- weighted_matrix_of_connectivity: This is a matrix size (number of
% nodes x number of nodes). If weighted_matrix_of_connectivity(i,j)
% does not equal zero then there the algorithm returns a branch between
% nodes i and j. The value of weighted_matrix_of_connectivity(i,j) is the
% mutual information, MI between i and j.

%tic % For timing performance.
% Find the number of buses.
number_of_buses = numel(MI_matrix(:,1));
% Create a variable that keeps track of the number of branches returned by
% the algorithm.
number_of_branches = 0; % initialized to zero.
% Initialize the matrix of connectivity.
weighted_matrix_of_connectivity = zeros(number_of_buses,number_of_buses);
% This keeps track of the rank of a node. This keeps track of many levels
% of parents the node has.
rank_vector = zeros(number_of_buses, 1);
root_vector = linspace(1,number_of_buses,number_of_buses);
% This function finds the root of a node. In other words, itt finds the 
% ultimate parent of the node. 
find_root = @find_root_w_path_compression;

% We look at the MI_matrix to find the maximum pair-wise mutual
% information. Initially we set the maximum we have found to be equal to
% zero.
max_MI = 0;
size_of_MI_matrix = size(MI_matrix);

while number_of_branches < (number_of_buses - 1)
    % find the max value in A, M corresponds to the value, I to the index 
    % of MI_matrix(:). 
   
    [max_MI,I] = max(MI_matrix(:)); 
    % Now find the actual row and column indices.
    [I_row, I_col] = ind2sub(size_of_MI_matrix, I);
    
    % In case there are several branches of the same weight.
    x= I_row(1);
    y= I_col(1);
    
    % Find the root of vertex (I_row) and vertex (I_col)
    [r, root_vector] = find_root(x, root_vector);
    [s,root_vector] = find_root(y, root_vector);

    % Check if roots are the same.
    if r == s;
        
    elseif rank_vector(r) > rank_vector(s)
        root_vector(r) = s;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    elseif rank_vector(s) > rank_vector(r)
        root_vector(r) = s;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    else
        root_vector(r) =s;
        rank_vector(s) = rank_vector(s) +1;
        weighted_matrix_of_connectivity(x,y) = max_MI;
        weighted_matrix_of_connectivity(y,x) = max_MI;
        number_of_branches = number_of_branches +1;
    end
    
    % Set the value of the MI_matrix to a very negative number
    % to avoid testing the same branch again. 
    MI_matrix(x,y) = -10E8;
end

% disp('time required to find min span tree of data')
% toc
end







