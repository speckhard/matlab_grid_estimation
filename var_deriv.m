function node_volt_deriv_mat = var_deriv(node_volt_mat, deriv_step)

% This function takes a varying difference of the node volt data depending
% on the vaue of deriv step.

% Input: 
% node_volt_mat: voltage measurements at different nodes (columns signify
% different nodes) and at different times (rows). Time step assumed to be
% the same unit as deriv step. If not conversion must be performed prior to
% input. 
% deriv_step: The voltage(time t, node x)' = v(t, x) - v(t-deriv_step,x).

% Output: Is the voltage subtracted by the a variable step in the past at
% the same node as defined above in deriv step.

delay = deriv_step;
node_volt_deriv_mat = node_volt_mat(delay+1:end,:)-...
    node_volt_mat(1:end-delay,:);
