% Downsample_v Test

% Test script for consider_derivative matlab function.
% Author: DTS
% First Created: 2/11/2016

% This script tests the downsampling function of downsample_v.

% We set the downsampling rate to be 3 mins, or 1 datapoint per 3 rows,
% assuming each row corresponds to a minute of data. 
time_interval_in_mins = 3;

test_voltage_meas_matrix = [3, 4; 3, 3; 10, 12; 4, 4; 5, 5; 6, 6; 7, 7; ...
    9, 9; 12 15; 21 45];
% Using a down_sampling interval of 3 rows, We expect the last row of data 
% to be retained.
expected_voltage_meas_matrix = [10,12; 6, 6; 12 15];
% If we set the avg_option_flag to 1, we expect the avg of this interval to
% be reatined. 
expected_voltage_meas_matrix_avg = [mean([3,3,10]), mean([4,3,12]);
    mean([4,5,6]), mean([4,5,6]); mean([7,9,12]), mean([7,9,15])];

expected_voltage_meas_matrix_avg_deriv = [mean([4,5,6])-mean([3,3,10]),...
    mean([4,5,6])-mean([4,3,12]); mean([7,9,12])-mean([4,5,6]), ...
    mean([7,9,15])-mean([4,5,6])];

expected_voltage_meas_matrix_median_deriv = [median([4,5,6])-median([3,3,10]),...
    median([4,5,6])-median([4,3,12]); median([7,9,12])-median([4,5,6]), ...
    median([7,9,15])-median([4,5,6])];

expected_voltage_meas_matrix_first = [3 4; 4 4; 7 7];
    

test_function = @downsample_v;

%% Test with last downsampling method, no deriv.
output_voltage_meas_matrix = ...
    test_function(test_voltage_meas_matrix, time_interval_in_mins,...
    'last', 'vmag');

if isequal(output_voltage_meas_matrix, expected_voltage_meas_matrix)
    disp(['down_sampling function performing well with no flags', ...
    ' on voltage measurement data'])
else
    disp(['down_sampling function performing incorrectly with no flags',...
    ' on voltage measurement data'])
end
%% Test with avg flag set to take mean, no deriv
output_voltage_meas_matrix = ...
    test_function(test_voltage_meas_matrix, time_interval_in_mins,...
    'mean', 'vmag');
if isequal(output_voltage_meas_matrix, expected_voltage_meas_matrix_avg)
    disp(['down_sampling function performing well with avg flags', ...
    ' on voltage measurement data'])
else
    disp(['down_sampling function performing incorrectly with avg flags',...
    ' on voltage measurement data'])
end

%% Test with mean downsampling, deriv afterwards
output_voltage_meas_matrix = ...
    test_function(test_voltage_meas_matrix, time_interval_in_mins, ...
    'mean', 'deriv');
if isequal(output_voltage_meas_matrix, ...
        expected_voltage_meas_matrix_avg_deriv)
    disp(['down_sampling function performing well with avg/deriv flags', ...
    ' on voltage measurement data'])
else
    disp(['down_sampling function performing incorrectly with avg/deriv flags',...
    ' on voltage measurement data'])
end

%% Test with median downsampling, deriv afterwards
output_voltage_meas_matrix = ...
    test_function(test_voltage_meas_matrix, time_interval_in_mins, ...
    'median', 'deriv');
if isequal(output_voltage_meas_matrix, ...
        expected_voltage_meas_matrix_median_deriv)
    disp(['down_sampling function performing well with median/deriv flags', ...
    ' on voltage measurement data'])
else
    disp(['down_sampling function performing incorrectly with median/deriv flags',...
    ' on voltage measurement data'])
end

%% Test first type downsampling

output_voltage_meas_matrix = ...
    test_function(test_voltage_meas_matrix, time_interval_in_mins, ...
    'first', 'no deriv');

if isequal(output_voltage_meas_matrix, ...
        expected_voltage_meas_matrix_first)
    disp(['down_sampling function performing well with first flag', ...
    ' on voltage measurement data'])
else
    disp(['down_sampling function performing incorrectly with first flag',...
    ' on voltage measurement data'])
end
