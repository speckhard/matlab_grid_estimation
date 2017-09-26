% Find incorrect branches

function incorrect_branch_mat = incorrect_branches(true_branch_mat, ...
    est_branch_mat)

% Function returns the branches that were estimated incorrectly by the grid
% estiamtion algorithm.

% Input: True_branch_mat is the the matrix size number of branches x 2 for a
% tree graph. Is is the list of correct branches in the grid, where each
% branch is a row. 
% Est_branch_mat is the the matrix size number of branches x 2 for a tree
% graph. It is a list of estimated branchses in the grid where each branch
% is a row.

% Ouput: incorrect_branch_mat is the matrix size # number of incorrect
% branches x 2. It a list of incorrect branches where each branch is a row.


% Check inputs, and ensure size of true branch mat is the same as est
% branch mat. 

if size(est_branch_mat) ~= size(true_branch_mat)
    error(['The size of the estiamted branch matrix is not', ...
        'the same as the size of the true branch matrix.'])
end


% Store the number of branches to use as iteration loop maximum.
num_branches = numel(true_branch_mat(:,1));
% Initialize a matrix to store incorrect branches.
incorrect_branch_mat = zeros(size(true_branch_mat));
% Create a variable to keep track of how many incorrect branches have been
% found. 
incorrect_counter = 0;
% Check all branches to see if they are correct.
for i = 1:num_branches
    if ~(ismember(est_branch_mat(i,:), ...
            true_branch_mat,'rows')) && ...
            ~(ismember([est_branch_mat(i,2), ...
            est_branch_mat(i,1)], true_branch_mat...
            ,'rows'))
        incorrect_counter = incorrect_counter +1;
        incorrect_branch_mat(incorrect_counter,:) = ...
            est_branch_mat(i,:);      
    end
end

% Now remove all the empty rows in the incorrect_branch_mat.
incorrect_branch_mat = incorrect_branch_mat(1:incorrect_counter,:);
end


       