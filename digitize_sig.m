function digitized_mat = digitize_sig(input_matrix, bits, global_min, ...
    global_max, dig_flag)

% digitized_mat = digitize_sig(input_matrix, bits, global_min, ...
%    global_max, dig_flag)
%
% This function discretizes the voltage magnitude data at each node. The
% discrization precision is a variable that is controlled. The binning
% process, the size of each bin, is also variable. 
%
% Input:
% ----- node_volt_matrix: A matrix containing the voltage magnitude data.
% The number of columns should be the number of nodes in the system. The
% number of rows in the matrix corresponds to the number of datapoints
% where the voltage magnitude is measured across all nodes.
% ----- global_min: This variable sets a minimum value for the 
% discretization binning process. If gloabl_min is set to 'local' then 
% the data is binned between the global minimum of the data in 
% node_volt_matrix and global_max.
% ----- global_max: This variable sets a maximum value for the 
% discretization binning process. If gloabl_min is set to 'local' then the 
% data is binned between the global minimum of the data in node_volt_matrix
% and the global_max.
% ----- dig_flag: This flag sets how the discretization binning process
% should run. If the dig_flag is set to 'even_spaced' then the 2^(num_bits 
% -1) bins are equally spaced. If the dig_flag is set to 'fd' the
% freidman-diaconis binning algorithm is used. 
%
% Ouput:
% ----- digitized_mat: This matrix is the size of the input
% node_volt_matrix. The values in this matrix are all integers. The values
% in digitized mat, digitized_mat(i,j), are equal to the bin number
% which the value node_volt_matrix(i,j) falls into with respect to the
% binning process specified in dig_flag.

tic % For timing purpuses.

% Check to see if we should use the local or the global min.
if strcmp(global_min, 'local')    
    % Set the global min to the local min.
    global_min = min(min(input_matrix));
end

% Check to see if we should use the local or the global max.
if strcmp(global_max, 'local')
    % Set the global min to the local min.
    global_max = max(max(input_matrix));
end

% Shift the data so new minimum is at zero.
if strcmp('even_spaced', dig_flag)
    % This new matrix has it's minimum value equal to zero.
    min_zero_mat = input_matrix - global_min;
    % Determine the bin-size for equally spaced bins.
    bin_size = (global_max-global_min)/(2^bits - 1);
    % Now find new values for data:
    digitized_mat = round(min_zero_mat./bin_size);
    
% We are also exploring more sophisticated disretization schemes that don't
% create equally spaced bins. The below code bins data according to the
% diaconis algorithm. The below code has yet to be used for published
% results.
elseif strcmp(dig_flag, 'fd')
    [digitized_mat, edges] = histcounts(input_matrix, 2^bits -1, ...
        'BinMethod', 'fd');
end

disp('time to digitize data')
toc
end



