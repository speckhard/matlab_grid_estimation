function sig_dig_node_volt_mat = sig_dig(node_volt_matrix, sig_dig)

% This function rounds the data in node_volt_matrix to the significant
% digit specified in sig_dig.

sig_dig_node_volt_mat = round(node_volt_matrix*sig_dig);
end
