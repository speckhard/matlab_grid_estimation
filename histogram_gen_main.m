% Main file to find leaf node SDR of SG datasets
% Last edit: 11/27

%% Setup data
% SG2
% First, copy the data minus the feeder bus
% data_limits = 'W10..BV525610';
% node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt.csv',...
%    9,22, data_limits);
% node_volt_matrix = SG2datavolt15min(:,1:272);
% Second, copy the list of true branches.
true_branch_data = Truebranchlist;

% % SG1
% % Feeder node, in this case Node 53.
% slack_bus = SGdatanodevolt(:,53);
% % First, copy the data minus the slack bus
% node_volt_matrix = SGdatanodevolt(:,1:52);
% % Second, copy the list of true branches.
% true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

% European Data-sets
node_volt_matrix = v_vec(:,1:end-1);
load('/Users/Dboy/Documents/Stanny/Rajagopal/LV_data/two_substation.mat')

%% Remove redundant nodes from the dataset.
collapse_data = @collapse_redundant_data;
[node_volt_matrix, true_branch_data] = ...
    collapse_data(node_volt_matrix, true_branch_data);
%% Remove Redundant Branches
remove_useless_branches = @remove_redundant_branches;
true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead
% take_derivative = @consider_derivative;
% node_volt_matrix = take_derivative(node_volt_matrix);
%% Consider variable deiv
% var_deriv_step = @var_deriv;
% node_volt_matrix_1 = var_deriv_step(node_volt_matrix, 60);

%% Plot The histograms of 4 nodes in the data-set
%% 1 min
hold off
subplot(3,2,1)
take_derivative = @consider_derivative;
node_volt_matrix_0 = take_derivative(node_volt_matrix);
b =9;
h = histogram(node_volt_matrix_0(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_0(:,b))
sigma = std(node_volt_matrix_0(:,b))
y = min(node_volt_matrix_0(:,b)):0.0001: ...
    max(node_volt_matrix_0(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('2-Substation: Node9')
%% hold off
subplot(3,2,2)
b =18;
h = histogram(node_volt_matrix_0(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_0(:,b))
sigma = std(node_volt_matrix_0(:,b))
y = min(node_volt_matrix_0(:,b)):0.0001: ...
    max(node_volt_matrix_0(:,b));

% h = histogram(node_volt_matrix(:,b),'Normalization', 'pdf');
% mu = mean(node_volt_matrix(:,b))
% sigma = std(node_volt_matrix(:,b))
% y = min(node_volt_matrix(:,b)):0.0001: ...
%     max(node_volt_matrix(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('2-Substation: Node18')
%% 30 min
% dsample_v = @downsample_v;
% node_volt_matrix_1 = dsample_v(node_volt_matrix, 30, 'first', 'deriv');
hold off
subplot(3,2,3)
b =9;
h = histogram(node_volt_matrix_1(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_1(:,b))
sigma = std(node_volt_matrix_1(:,b))
y = min(node_volt_matrix_1(:,b)):0.0001: ...
    max(node_volt_matrix_1(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('2-Substation: Node18')
%% 

%node_volt_matrix_1 = dsample_v(node_volt_matrix, 30, 'first', 'deriv');
hold off
subplot(3,2,4)
b =18;
h = histogram(node_volt_matrix_1(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_1(:,b))
sigma = std(node_volt_matrix_1(:,b))
y = min(node_volt_matrix_1(:,b)):0.0001: ...
    max(node_volt_matrix_1(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('SG1:Node18, 30min Resolution')
%%
hold off
subplot(3,2,5)


node_volt_matrix_2 = dsample_v(node_volt_matrix, 60, 'first', 'deriv');

b =9;
h = histogram(node_volt_matrix_2(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_2(:,b))
sigma = std(node_volt_matrix_2(:,b))
y = min(node_volt_matrix_2(:,b)):0.0001: ...
    max(node_volt_matrix_2(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('SG1:Node9, 60min Resolution')
%% 
hold off
subplot(3,2,6)

b =18;
h = histogram(node_volt_matrix_2(:,b),'Normalization', 'pdf');
mu = mean(node_volt_matrix_2(:,b))
sigma = std(node_volt_matrix_2(:,b))
y = min(node_volt_matrix_2(:,b)):0.0001: ...
    max(node_volt_matrix_2(:,b));

hold on
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%title('Histogram/Gaussian-Fit SG1, Node 18')
xlabel('Voltage Magnitude (V)')
ylabel('Probability Density')
%legend({'Histogram','Gaussian Fit'}, 'Location','southwest')
set(gca,'FontSize',12);
title('SG1:Node18, 60min Resolution')
