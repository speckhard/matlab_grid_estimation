function reflected_mat = reflect_lower_triang_mat(input_mat)

% This function reflects the lower triangular portion of a matrix to the
% the upper triangular portion of the matrix

num_rows = numel(input_mat(:,1));
% Copy the reflected mat from the input mat
reflected_mat = input_mat;
for i = 2:num_rows
    for j = 1:i-1
        if i == j
            error('fatal error, row index meets column index')
        end
        reflected_mat(j,i) = input_mat(i,j);
    end
end
