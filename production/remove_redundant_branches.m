function true_branches = remove_redundant_branches(true_branches)

% true_branches = remove_redundant_branches(true_branches)
%
% This function takes in the true branch data which may have redundant
% branches (self-referrring branches) like [2,2] or [34,34]. If redundant
% branches are found, they are removed. 
%
% Input:
% ----- true_branches: This is a matrix containing the true branches in
% the system. The number of rows in this matrix corresponds to the number
% of true branches in the system. THe number of columns should be equal to
% two, which is the number of nodes involved in a single branch. This
% matrix may contain redundant self-referring branches like [1,1] or [3,3]
% that arise after calling collapse_redundant_data.m. 
%
% Ouput:
% ----- true_branches: This is a matrix containing the true branches in
% the system and containing no redundant branches (e.g. [2,2]).

tic
branch_counter = 1;
while branch_counter <= numel(true_branches(:,1))
    if true_branches(branch_counter, 1) == ...
            true_branches(branch_counter,2)
        true_branches(branch_counter, :) = [];
    else
        branch_counter = branch_counter + 1;
    end
end
disp('time to remove redundant branches')
toc

end