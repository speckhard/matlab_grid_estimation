function node_volt_matrix_lens = ...
    sliding_lens(node_volt_matrix, lens_length, lens_number)

% Function will take a lens of the node_volt matrix and will 
node_volt_matrix_lens = node_volt_matrix(lens_number/2*lens_length:...
    lens_number/2*lens_length+lens_length,:);
end
