function node_volt_matrix = consider_derivative(node_volt_matrix)

% node_volt_matrix = consider_derivative(node_volt_matrix)
%
% This function takes voltage magnitude data for the nodes in the system
% and returns the change in voltage magnitude between sucessive time-points
% for the nodes in the system. Since this process is similar to taking the
% deriative, the function is called consider_derivative.
%
% Input:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
%
% Output:
% ----- node_volt_matrix: The output matrix is the same size as the input
% except that it has one less row of data. The first row of data is removed 
% after the change in voltage magnitude is calculated since the first row 
% has no previous time point with which we find the change in voltage 
% magnitude. The values in the output matrix are equal to the 
% change in voltage mangnitude, Delta_Vmag = Vmag(node x, time t) - 
% Vmag(node x, time t-1). We use the same name for the output as for the
% input since this matrix can be quite large and creating a newly named
% variable results in an extra copy of the data created by Matlab.

tic % For timing analysis we time the function. 
for i = 1:numel(node_volt_matrix(1,:))
    % Subtract the voltage magnitude data by the previous time measurement.
    node_volt_matrix(2:end,i) = node_volt_matrix(2:end,i) ... 
        - node_volt_matrix(1:(end-1),i);
end

% We drop the first row of data in the node volt matrix since it has not
% been subtracted by data at a previous time-point.
node_volt_matrix = node_volt_matrix(2:end,:);

disp('time to find the change in voltage magnitude of the data')
toc
end