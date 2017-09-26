%% First, copy all of the Sandia data into a new matrix, avoid copying the
% Feeder node, in this case Node 53.
slack_bus = SGdatanodevoltsolar(:,53);
% First, copy the data minus the slack bus
node_volt_matrix = SGdatanodevoltsolar(:,1:52);
% Second, copy the list of true branches.
true_branch_data = SandiaNationalLabTrueNodeData(1:51,:);
%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data);  
% %% Take Deriv First
take_deriv = @consider_derivative;
node_volt_matrix = take_deriv(node_volt_matrix);
%% Now let's downsample
downsampler = @downsample_v;
downsampling_interval_mins = 60; % every sixty mins one sample is saved
node_volt_matrix_downsampled = downsampler(node_volt_matrix, ...
    downsampling_interval_mins, 'median', 'noderiv');

%% Plot The 
hold off
b = 9;
h = histogram(node_volt_matrix_downsampled(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_downsampled(:,b))
sigma = std(node_volt_matrix_downsampled(:,b));
y = min(node_volt_matrix_downsampled(:,b)):0.0001: ...
    max(node_volt_matrix_downsampled(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
title('Histogram/Gaussian of Deriv,Median collapsed-Sandia, Node 9')
xlabel('Voltage Difference From Previous Measurement (V)')
ylabel('Probability Density')
legend('pdf hist','gaussian approx from mean and std')