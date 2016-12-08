%% Testing est_MI_MLE.m function
% We want to compare performance of the est_MI_MLE.m function to the
% discrete MI function developed in the S3L. 

% Author: DTS
% Date: 12/6/2016;

node_volt_matrix = v_vec(:,2:end);% SGdatanodevoltsolar;% SGdatasolar60min;
% digitize the data 
digitizer = @digitize_sig;
node_volt_matrix_digital = digitizer(node_volt_matrix, 14, 'local','local');
% num_buses = numel(node_volt_matrix(1,:));
JVHW = @find_JVHW_MI;
MLE = @find_MLE_MI;
discrete = @MI_vmag_discrete;

tic
MI_JVHW = JVHW(node_volt_matrix_digital,'no diagonals');
disp('time to find the JVHW MI')
toc 
tic 
MI_MLE = MLE(node_volt_matrix_digital, 'no diagonals');
disp('time fo find te MLE MI')
toc
tic
MI_discrete = discrete(node_volt_matrix_digital, 14);
disp('time to find the discrete MI')
toc


