function [succesful_branch_counter, SDR] = findSDR(estimated_branch_list, ...
    true_branch_list)

%tic
% The number of buses should be one greater than the number of estimated
% branches.
number_of_buses = 1 + numel(estimated_branch_list(:,1));
% this is our succesful detection counter, it is incremented if we can
% find a match between our valid_pairs_of_nodes and the real branches in
% the grid, mpc_base.branch(:,1:2).
sdr_counter = 0 ;

% Here we should consider ordering the valid branches so that the smaller
% branch node is always on the left hand side (LHS). Instead, here we check
% for both possibilities, changing the valid branch node pairs ordering
% in case a match isn't found.

for i = 1:(number_of_buses-1)
    
    % note we subtract the ones vector since mpc_base.branch's 
    % numbering is off by one (it includes the slack bus).
    if (ismember(estimated_branch_list(i,:), ...
            true_branch_list,'rows'))
        sdr_counter = sdr_counter +1;
    elseif (ismember([estimated_branch_list(i,2), ... 
            estimated_branch_list(i,1)], true_branch_list...
            ,'rows'))
        sdr_counter = sdr_counter +1;
    end
    
end

% The number of sucessfully detected branches is:
succesful_branch_counter = sdr_counter;
% The succesful detection rate is:
SDR = sdr_counter/(number_of_buses-1)*100;

%disp('time required to find the succesful detection rate')
%toc