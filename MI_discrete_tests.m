% Main File to run MI Methods vs SDR, where derivative can be switched on
% and off. 

%% First, copy all of the Sandia data into a new matrix, avoid copying the
data_limits = 'W10..KI35050';
node_volt_matrix = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/SG2_data_volt_60min.csv',...
   9,22, data_limits);
%% Second, copy the list of true branches.
data_limits = 'A1..B271';
true_branch_data = csvread('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Sandia Data/R4_12_47_True_branch_list.csv',...
    0,0, data_limits);
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Run Chow-Liu
num_bits_vector = [12 14] %,6,8,10,12];
sdr_mat = zeros(3, numel(num_bits_vector));
for j = 1:numel(num_bits_vector);
    for i = 1:3
        num_bits = num_bits_vector(j);
        if i == 1
            MI_vector = 'gaussian';
            %num_bits = 'no discretization';
        elseif i == 2
            MI_vector = 'JVHW';
        else i == 3
            MI_vector = 'discrete';
        end
        
        %% Run Chow-Liu 
        compute_sdr = @run_chow_liu_options;
        sdr = compute_sdr(node_volt_matrix,true_branch_data, ...
            MI_vector,'no_deriv','nograph','no heat_map', num_bits)
        sdr_mat(i,j) = sdr;
    end
end
%% Save Data
save('/afs/ir.stanford.edu/users/d/t/dts/Documents/Rajagopal/Results','sdr_mat')