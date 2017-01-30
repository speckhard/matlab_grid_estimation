function digitized_mat = digitize_sig(input_matrix, bits, global_min, ...
    global_max, dig_flag)

tic
bits
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
if strcmp('even_spaced', dig_flag)
    min_zero_mat = input_matrix - global_min;
    
    bin_size = (global_max-global_min)/(2^bits - 1);
    
    % Now find new values for data:
    
    digitized_mat = round(min_zero_mat./bin_size);
    
    % If the num bits is lower than 16, let's save space and save the matrix a
    % a matrix of uint16 values.
    
    % if bits < 16
    %     digitized_mat = uint16(digitized_mat);
    %     disp('creating 16 bit mat.')
    % end
    
elseif strcmp(dig_flag, 'fd')
    [digitized_mat, edges] = histcounts(input_matrix, 2^bits -1, ...
        'BinMethod', 'fd');
end

disp('time to digitize data')
toc
end



