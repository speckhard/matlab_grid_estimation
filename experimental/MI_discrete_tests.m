% Main File to run MI Methods vs SDR, where derivative needs to be set
% further down.
%% First, copy all except feeder SG data into a new matrix.
% 60 min file has 8770 datapoints
% 15 min file has 35050 datapoints
% Column W corresponds to Node 1, Column KI corresponds to node 272. We
% purposely leave out the feeder node since it's vmag value is not constant. 
data_limits = 'W10..KI525610';
node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_1min.csv',...
   9,22, data_limits);
%% Second, copy the list of true branches.
data_limits = 'A1..B271';
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
    0,0, data_limits);
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches.
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative of Data. 
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Run Chow-Liu
num_bits_vector = [14];
% Create a matrix to save SDR data.  
sdr_mat = zeros(3, numel(num_bits_vector));
compute_sdr = @run_chow_options;

for j = 1:numel(num_bits_vector);
    for i = 1:3
        num_bits = num_bits_vector(j);
        if i == 1
            MI_vector = 'gaussian';
            num_bits = 'no discretization';
        elseif i == 2
            MI_vector = 'JVHW';
        else i == 3
            MI_vector = 'discrete';
        end      
        % Run Chow-Liu, return the sdr and the estimated branch list.       
        sdr = compute_sdr(node_volt_matrix,...
            true_branch_data, MI_vector,'no_deriv','nograph',...
            'no heat_map', num_bits)
        % Generate a status report on the estimated_branch_list. 
        sdr_mat(i,j) = sdr;
    end
end
%% Save Data
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results/SG-1min-deriv'...
    ,'sdr_mat')