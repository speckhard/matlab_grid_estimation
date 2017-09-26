function reflected_mat = reflect_lower_triang_mat(input_mat)

% reflected_mat = reflect_lower_triang_mat(input_mat)
%
% This function reflects the lower triangular portion of a matrix to the
% the upper triangular portion of the matrix.
%
% Input:
% ----- input_mat: This is typically a mutual information matrix that
% should be symmetric. Often times only the lower half of the matrix is 
% populated to improve performance. This function reflects lower triangular
% values across the diagonal.
%
% Ouput:
% ----- reflected_mat: This ouput matrix is symmetric about the diagonal.
% The lower triangular values are equal to the upper triangular values. Ex.
% reflected_mat(1,2) = reflected_mat(2,1).

num_rows = numel(input_mat(:,1));
% Copy the reflected mat from the input mat.
reflected_mat = input_mat;
for i = 2:num_rows
    for j = 1:i-1
        if i == j
            error('fatal error, row index meets column index')
        end
        reflected_mat(j,i) = input_mat(i,j);
    end
end
