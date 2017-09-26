function [max_diff, min_diff, mean_diff, stdev_diff] = ...
    MI_mat_diff(MI_mat_x, MI_mat_y);

% Find the error between two MI matrices

% Check to see if both matrices are the same size
if size(MI_mat_x) ~= size(MI_mat_y)
    error('input matrices are not the same size')
end

num_buses = numel(MI_mat_x(:,1));
abs_diff_vec = zeros(1,num_buses*(num_buses-1));

for i = 2:num_buses
    for j = 1: i -1
        abs_diff_vec(i+j - 2) = abs(MI_mat_x(i,j) - MI_mat_y(i,j));
    end
end

max_diff = max(abs_diff_vec);
mean_diff = mean(abs_diff_vec);
min_diff = min(abs_diff_vec);
stdev_diff = std(abs_diff_vec);
end

        