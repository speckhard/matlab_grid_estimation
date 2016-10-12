% This function sorts the mutual information values into a vector
function sorted_MI_nodes = sort_MI(mutual_info_matrix)

% INPUT: mutual_info_matrix which is size (number of buses, 
% number of buses). The mutual info matrix is only non-zero for lower 
% triangular values since mutual info is symmetric I(1,2) = I(2,1) and
% we don't care about self-information I(1,1).

% OUTPUT: A matrix size [(number of buses-1)*(number of buses)/2, 2] which 
% account for all the values in the lower triangular portion of the 
% mutual_info_matrix input. The sorted_MI_nodes matrix contains sorted 
% indices corresponding to the the largest mutual info between nodes 
% at the top of the matrix to the lowest mutual info between nodes at 
% at the bottom.

% function flow:
% 1. we take all the values from the lower triangular portion of mutual
% info matrix and place them into a vector.
% 2. we sort the all the mutual information values.
% 3. we find the indices corresponding to the sorted mutual info values
% and store the indices in the sorted_MI_nodes matrix.

% first let's caluclate the number of buses in the incoming matrix
number_of_buses = numel(mutual_info_matrix(1,:));

% Since we're looking for a second-order probability distributions
% and we assume bus 1 (i.e. bus 2 from the original data), in the data set
% without the slack bus, is connected to the slack bus, we can tell
% the maximum number of connections.
% max_number_of_connections = number_of_buses - 1; % unused variable

% column vector of the unsorted_mutual_information spotted is initialized to zero
unsorted_mutual_information = zeros((number_of_buses-1)*number_of_buses/2,1);
index_for_sorting = 1;

% We keep track of how unsorted_mutual_information corresponds to indices.
% unsorted_mutual_information is a column vector and we wish to know
% what indices in the grid (i,j) correspond to a row in
% unsorted_mutual_information. We do so in unsorted_MI_node_pairs.
unsorted_MI_node_pairs = zeros((number_of_buses-1)*number_of_buses/2,2);

% This for loop starts at i = 2, since the first row contains I(1,1)
% which is the self-information of bus i, which is not relevant for our
% approximation.

for i = 2:number_of_buses
    for k = 1:(i-1)
        unsorted_mutual_information(index_for_sorting) = ...
            mutual_info_matrix(i,k);
        % let's also store what indices this value corresponds to:
        unsorted_MI_node_pairs(index_for_sorting,:) = [i, k];
        % now let's increment the value for sorting.
        index_for_sorting = index_for_sorting+1;
    end
end


% now sort the sorted_mutual_information
sorted_mutual_information = sort(unsorted_mutual_information,'descend');

% now create a matrix with the pairs of nodes corresponding to sorted
% mutual information

sorted_MI_nodes = zeros(numel(sorted_mutual_information), 2);

i = 1;
while (i<= numel(sorted_mutual_information))
    
    [r]=find(unsorted_mutual_information== sorted_mutual_information(i));
    
    % Let's check if there are multiple mutual information values that
    % are the same. We treat this case below:
    number_of_identical_mutual_information_vals = numel(r);
    
    if number_of_identical_mutual_information_vals == 1
        sorted_MI_nodes(i,:) = unsorted_MI_node_pairs(r,:);
        i = i + 1;
    else 
        for k = 1:number_of_identical_mutual_information_vals
            %number_of_identical_mutual_information_vals
           sorted_MI_nodes(i+k,:) = unsorted_MI_node_pairs(r(k),:);
           
        end
   % increment the iteration variable i by num of identical
   % mutual information vals so we can move on to the next mi val
   i = i + number_of_identical_mutual_information_vals;
    end
end

