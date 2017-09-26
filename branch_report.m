function estimated_branch_report = branch_report(estimated_branch_list, ...
    true_branch_list);

% Script to save incorrectly predicted branches and to note whether the 
% incorrectly predicted branch contains a leaf node. 

% Input: Estimated_branch_list - The list of branches predicted by the 
% run_chow_liu_return_list.m file. 

% True_branch_list - The list of true branches.

% Ouput: A matrix with the incorrect branch list occupying columns one and
% two, and whether a leaf is a contained in the row's incorrectly predicted
% branch in column 3. [incorrect_branch_node_1, incorrect_branch_node_2,
% leaf_indicator] is a desicription of the output array. 

% Find incorreclty predicted branches.
num_branches = numel(true_branch_list(:,1);
incorrect_branch_list = zeros(2, num_branches);
incorrect_branch_counter = 0;
sdr_counter = 0;

for i = 1:num_branches;
    if (ismember(estimated_branch_list(i,:), ...
            true_branch_list,'rows'))
        sdr_counter = sdr_counter +1;
    elseif (ismember([estimated_branch_list(i,2), ... 
            estimated_branch_list(i,1)], true_branch_list...
            ,'rows'))
        sdr_counter = sdr_counter +1;
    else % save the incorrectly predicted branch. 
        incorrect_branch_counter = incorrect_branch_counter +1;
        incorrect_branch_list(incorrect_branch_counter,:) ...
            = estimated_branch_list(i,:)
    end   
end

% Remove empty lines in the incorrect_branch_list array.
incorrect_branch_list = ...
    incorrect_branch_list(1:incorrect_branch_counter,:);

% Find if a branch is connected to leaf node. 
leaf_node_indicator = zeros(incorrect_branch_counter,1);
% Find the leaf nodes in the true branch list.
leaf_node_list = find_eaf_nodes(true_branch_list);
for i = numel(leaf_node_list);
    for j = 1:incorrect_branch_counter;
        if sum(ismember(incorrect_branch_list(j,:), leaf_node_list(i))) ~=0
            leaf_node_indicator = 1;
        else leaf_node_indicator = 0;
        end
    end
end

leaf_percent = numel(leaf_percent)/num_branches*100
estimated_branch_report = [incorrect_branch_list, leaf_node_indicator];     


