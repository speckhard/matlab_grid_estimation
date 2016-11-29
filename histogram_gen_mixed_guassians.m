% Main file to find leaf node SDR of SG datasets
% Last edit: 11/27

%% Setup data
% SG2
% First, copy the data minus the feeder bus
node_volt_matrix = SG2datavolt15min(:,1:272);
% Second, copy the list of true branches.
true_branch_data = Truebranchlist;

% % SG1
% % Feeder node, in this case Node 53.
% slack_bus = SGdatanodevolt(:,53);
% % First, copy the data minus the slack bus
% node_volt_matrix = SGdatanodevolt(:,1:52);
% % Second, copy the list of true branches.
% true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

% %% Remove redundant nodes from the dataset.
% collapse_data = @collapse_redundant_data;
% [node_volt_matrix, true_branch_data] = ...
%     collapse_data(node_volt_matrix, true_branch_data);
% %% Remove Redundant Branches
% remove_useless_branches = @remove_redundant_branches;
% true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead
% take_derivative = @consider_derivative;
% node_volt_matrix = take_derivative(node_volt_matrix);
%% Consider variable deiv
% node_volt_matrix = var_deriv_step(node_volt_matrix, 15);

%% Plot The 
hold off
b =120;
h = histogram(node_volt_matrix(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix(:,b))
sigma = std(node_volt_matrix(:,b))
y = min(node_volt_matrix(:,b)):0.0001: ...
    max(node_volt_matrix(:,b));

%% Find the Mixed Gaussian
GMModel = fitgmdist(node_volt_matrix(:,b),2,...
    'Options',statset('Display','final'))
%% mix gaussian plotting
hold on
mu1 = 7.5232E3
mu2 = 7.4632E3
sigma1 = sqrt(399.9124)
sigma2 = sqrt(571.1325)
f1 = 0.52*exp(-(y-mu1).^2./(2*sigma1^2))./(sigma1*sqrt(2*pi));
f2 = 0.48*exp(-(y-mu2).^2./(2*sigma2^2))./(sigma2*sqrt(2*pi));
plot(y,f1,y, f2,'LineWidth',2.5)
title('Histogram/Mixed-Gaussian-Fit SG2-15min, Node 120')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
legend('pdf hist','RHS Mixed Gaussian Approx (0.52%)',...
    'LHS Mixed Gaussian Approx (0.48%)')

