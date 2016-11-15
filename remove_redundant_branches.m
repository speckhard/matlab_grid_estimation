function True_Branch_Data = remove_redundant_branches(True_Branch_Data);

% This function takes in the True Branch Data which may have redundant
% branches (self-referrring branches) like [2,2] or [34,34]. If redundandt
% branches are found, they are removed. 

tic
branch_counter = 1;
while branch_counter <= numel(True_Branch_Data(:,1))
    if True_Branch_Data(branch_counter, 1) == ...
            True_Branch_Data(branch_counter,2)
        True_Branch_Data(branch_counter, :) = [];
    else
        branch_counter = branch_counter + 1;
    end
end
disp('time to delete self-referring nodes')
toc