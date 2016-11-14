function node_volt_matrix_output = downsample_v(node_volt_matrix_input, ...
    time_interval_in_mins, avg_option_flag, deriv_option_flag)

% This function takes downsamples the matrix of voltage measruments by
% either taking one sample per interval (ex. one per hour) or the average
% measuremnt per hour. The function also depending on the deriv flag takes
% the quasi derivative (difference between data points) of the data. 

%% Inputs:

% Node volt matrix: is a matrix of voltage measruments at different times
% corresponding to rows, and different nodes corresponding to columns. The
% sie of the node_volt_matrix is (num of measurements, num of nodes). 

% Time interval in mins, is the length of the time interval between which a
% a sample is saved (in mins). For ex, if time_interval_in_mins = 30, only
% sample is saved every 30 mins. 

% Avg_option_flag, if equal to 1, the average of the interval is retained,
% if not the last sample of the interval is retained.

% Deriv_option_flag, if equal to 1, the difference with respect to the
% previos sample is taken for each retained sample.

%% Output:

% The node volt matrix that has been downsampled is returned.

%% Function guts

% Number of nodes
num_nodes = numel(node_volt_matrix_input(1,:));

% Let's find how many datapoints in mins are in the input node volt matrix.
input_lens_mins = numel(node_volt_matrix_input(:,1));

% Find the num_down_samples
num_down_samples = floor(input_lens_mins/time_interval_in_mins)

% Initialize the node_volt_matrix_output
node_volt_matrix_output = zeros(num_down_samples, num_nodes);
% Check the avg option flag, if not one, proceed without averaging while
% downsampling.
if (strcmp(avg_option_flag,'last')) || (time_interval_in_mins == 1 )
   % Loop of the number of down_samples required.
    for partition_counter = 1:num_down_samples
        % Set the first sample of the output voltage matrix equal to the
        % last measurement in the interval ->
        % V(partition_counter*time_interval_in_mins).
        node_volt_matrix_output(partition_counter,:) = ...
        node_volt_matrix_input(partition_counter*...
        time_interval_in_mins,:);
    end
elseif strcmp(avg_option_flag,'mean')
    disp('taking mean')
    for partition_counter = 1:num_down_samples    
        % Take a time interval of the data and store the mean.
          % Take the interval of time, (partition_counter-1)* time_interval 
          % +1 until partion_counter*time_interval, and take the mean of
          % this interval and store it in the output node volt matrix.
        node_volt_matrix_output(partition_counter,:) = ...
          mean(node_volt_matrix_input((partition_counter-1)*...
          time_interval_in_mins+1:partition_counter*...
          time_interval_in_mins,:));
    end
elseif strcmp(avg_option_flag,'median')
    disp('taking median')
    for partition_counter = 1:num_down_samples    
        % Take a time interval of the data and store the mean.
          % Take the interval of time, (partition_counter-1)* time_interval 
          % +1 until partion_counter*time_interval, and take the mean of
          % this interval and store it in the output node volt matrix.
        node_volt_matrix_output(partition_counter,:) = ...
          median(node_volt_matrix_input((partition_counter-1)*...
          time_interval_in_mins+1:partition_counter*...
          time_interval_in_mins,:));
    end


elseif strcmp(avg_option_flag,'max')
    disp('taking max')
    for partition_counter = 1:num_down_samples    
        % Take a time interval of the data and store the mean.
          % Take the interval of time, (partition_counter-1)* time_interval 
          % +1 until partion_counter*time_interval, and take the max of
          % this interval and store it in the output node volt matrix.
        node_volt_matrix_output(partition_counter,:) = ...
          max(node_volt_matrix_input((partition_counter-1)*...
          time_interval_in_mins+1:partition_counter*...
          time_interval_in_mins,:));
    end
elseif strcmp(avg_option_flag,'min')
    disp('taking min')
    for partition_counter = 1:num_down_samples    
        % Take a time interval of the data and store the mean.
          % Take the interval of time, (partition_counter-1)* time_interval 
          % +1 until partion_counter*time_interval, and take the max of
          % this interval and store it in the output node volt matrix.
        node_volt_matrix_output(partition_counter,:) = ...
          min(node_volt_matrix_input((partition_counter-1)*...
          time_interval_in_mins+1:partition_counter*...
          time_interval_in_mins,:));
    end

elseif strcmp(avg_option_flag,'95th')
    for partition_counter = 1:num_down_samples    
        % Take a time interval of the data and store the mean.
          % Take the interval of time, (partition_counter-1)* time_interval 
          % +1 until partion_counter*time_interval, and take the 95th %
          % quartile of
          % this interval and store it in the output node volt matrix.
        node_volt_matrix_output(partition_counter,:) = ...
          quantile((node_volt_matrix_input((partition_counter-1)*...
          time_interval_in_mins+1:partition_counter*...
          time_interval_in_mins,:)),0.95,1);
    end
else
    error('no option chosen 4 avg flag choose last, median, min/max, 95')
end

if strcmp(deriv_option_flag,'deriv')
    take_deriv = @consider_derivative;
    node_volt_matrix_output = take_deriv(node_volt_matrix_output);
end


