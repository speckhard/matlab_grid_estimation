% Main file to find leaf node SDR of SG datasets
% Last edit: 11/27

%% Setup data
% SG2
% % First, copy the data minus the feeder bus
% node_volt_matrix = SG2datavolt15min(:,1:272);
% % Second, copy the list of true branches.
% true_branch_data = Truebranchlist;

data_limits = 'W10..AL525610';% 525610';%'W10..BV525610';%'W10..KH525610';

node_volt_matrix = csvread('/Users/Dboy/Downloads/SG_data_node_volt.csv',...
   9,22, data_limits);
% % SG1
% First, copy the data minus the slack bus
%node_volt_matrix = SGdatanodevolt(:,1:52);
% Second, copy the list of true branches.
%true_branch_data = SandiaNationalLabTrueBranchesData(1:51,:);

% %% Remove redundant nodes from the dataset.
% collapse_data = @collapse_redundant_data;
% [node_volt_matrix, true_branch_data] = ...
%     collapse_data(node_volt_matrix, true_branch_data);
% %% Remove Redundant Branches
% remove_useless_branches = @remove_redundant_branches;
% true_branch_data = remove_useless_branches(true_branch_data); 
%% Consider The Derivative Instead
take_derivative = @consider_derivative;
node_volt_matrix = take_derivative(node_volt_matrix);
%% Consider variable deiv
% node_volt_matrix = var_deriv_step(node_volt_matrix, 15);

%% Plot The 
hold off
b =9;
h = histogram(node_volt_matrix(:,b),10000,'Normalization', 'pdf');
mu = mean(node_volt_matrix(:,b))
sigma = std(node_volt_matrix(:,b))
y = min(node_volt_matrix(:,b)):1: ...
    max(node_volt_matrix(:,b));

%% Find the Mixed Gaussian
tic
GMModel = fitgmdist(node_volt_matrix(:,b),2,...
    'Options',statset('Display','final'))
toc
%% mix gaussian plotting
hold on
mu_vec = GMModel.mu;
sigma_vec = squeeze(GMModel.Sigma);
mu1 = mu_vec(1); %7.5232E3
mu2 = mu_vec(2); %7.4632E3
sigma1 = sigma_vec(1); %sqrt(399.9124)
sigma2 = sigma_vec(2); %sqrt(571.1325)
f1 = 0.52*exp(-(y-mu1).^2./(2*sigma1))./(sqrt(sigma1)*sqrt(2*pi));
f2 = 0.48*exp(-(y-mu2).^2./(2*sigma2))./(sqrt(sigma2)*sqrt(2*pi));
plot(y,f1+f2,'LineWidth',2.5)
plot(y,f1,'-.','LineWidth',2.5)
plot(y,f2,'g:','LineWidth',2.5)
%title('Histogram/Mixed-Gaussian-Fit SG1, Node 9')
xlabel('Voltage Magnitude Change (V)')
ylabel('Probability Density')
legend('Histogram', 'Gaussian Mix', ...
    'LHS Gaussian', 'RHS Gaussian')
%legend('pdf hist','RHS Mixed Gaussian Approx (0.52%)',...
   % 'LHS Mixed Gaussian Approx (0.48%)')
   set(gca,'FontSize',18);
   

