function digitized_mat = digitize_sig(input_matrix, bits, global_min, ...
    global_max)

tic
% Check to see if we should use the local or the global min
if strcmp(global_min, 'local')    
    % Set the global min to the local min.
    global_min = min(min(input_matrix));
end

% Check to see if we should use the local or the global max
if strcmp(global_max, 'local')    
    % Set the global min to the local min.
    global_max = max(max(input_matrix));
end
   
% Shift data so new min is at zero
%number_of_cols = numel(input_matrix(1,:));
%min_zero_mat = zeros(size(input_matrix));

min_zero_mat = input_matrix - global_min;

bin_size = (global_max-global_min)/(2^bits - 1);

% Now find new values for data:

digitized_mat = round(min_zero_mat./bin_size);

disp('time to digitize data')
toc
end



