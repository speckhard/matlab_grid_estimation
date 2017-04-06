function [succesful_branch_counter, SDR] = findSDR(estimated_branches, ...
    true_branches)

% [succesful_branch_counter, SDR] = findSDR(estimated_branches, ...
%    true_branches)
%
% Input:
% ----- estimated_branches: This is a matrix size (number of branches x 2)
% where each row is a pair of nodes corresponding to an estimated branch
% from the chow-liu algorithm output. The number of branches should be one
% less than the total number of nodes.
%
% ----- true_branches: This is a matrix containing the true branches in
% the system. The number of rows in this matrix corresponds to the number
% of true branches in the system. THe number of columns should be equal to
% two, which is the number of nodes involved in a single branch.
%
% Output:
% ------ successful_branch_counter: This is a integer counter that tells us
% how many branches have been correctly estimated by the algorithm.
%
% ------ SDR: This value is the successful detection rate (SDR) percentage
% of the estimation algorithm. It equals the number of correctly identified
% branches divided by the total number of branches.

% tic
% The number of buses should be one greater than the number of estimated
% branches.
number_of_buses = 1 + numel(estimated_branches(:,1));
% This is our succesful detection counter, it is incremented if we can
% find a match between our valid_pairs_of_nodes and the real branches in
% the grid, mpc_base.branch(:,1:2).
sdr_counter = 0;

% Here we check if the branch (essentially the row of estimated_branches)
% in estimated_branches is part of the true branch list in true_branches.
% If it is not, we reverse the ordering in estimated_branches(i,:) and
% check again. Ex. We check if (4,3) is a valid branch, if not we check if
% (3,4) is a valid branch.

for i = 1:(number_of_buses-1)
    if (ismember(estimated_branches(i,:), ...
            true_branches,'rows'))
        sdr_counter = sdr_counter +1;
    elseif (ismember([estimated_branches(i,2), ... 
            estimated_branches(i,1)], true_branches...
            ,'rows'))
        sdr_counter = sdr_counter +1;
    end
end

% The number of sucessfully detected branches is:
succesful_branch_counter = sdr_counter;
% The succesful detection rate is:
SDR = sdr_counter/(number_of_buses-1)*100;

% disp('time required to find the succesful detection rate')
% toc