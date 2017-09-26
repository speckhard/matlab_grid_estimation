function node_volt_matrix = var_deriv(node_volt_matrix, deriv_step)

% This function finds the change in voltage magntiude for a variable
% difference of time-points. The change in voltage magnitude is calculated 
% as Delta_Vmag = Vmag(node x, time t) - mag(node x, time t-deriv_step).
%
% node_volt_deriv_mat = var_deriv(node_volt_matrix, deriv_step)
%
% Input:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
% ----- deriv_step: This is an integer specifiying the number of timepoints
% for which the change in voltage magntiude is calculated. The change in 
% voltage magnitude is calculated as Delta_Vmag = Vmag(node x, time t) - 
% Vmag(node x, time t-deriv_step).
% Output:
% ----- node_volt_matrix: The output matrix is the same size as the input
% except that it has one less row of data. The first deriv_step (this is an
% integer) rows of data are removed after the change in voltage magnitude
% is calculated since the first deriv_step rows have no previous time point 
% with which we find the change in voltage magnitude. The values in the 
% output matrix are equal to the  change in voltage mangnitude, Delta_Vmag 
% = Vmag(node x, time t) - Vmag(node x, time t-deriv_step). We use the same 
% name for the output as for the input since this matrix can be quite large
% and creating a newly named variable results in an extra copy of the data 
% created by Matlab.

delay = deriv_step;
node_volt_matrix = node_volt_matrix(delay+1:end,:)-...
    node_volt_matrix(1:end-delay,:);
end

