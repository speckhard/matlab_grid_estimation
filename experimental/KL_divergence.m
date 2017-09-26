% Script to find DL between gaussian and pdf.

%%% 
data_limits = 'W10..BV8770'

node_volt_matrix2 = csvread('/Users/Dboy/Downloads/SG_data_solar_60min.csv',...
   9,22, data_limits);
% %% True branches 
% data_limits = 'A1..B271';%'A1..B51';%'A1..B271';
% true_branch_data = csvread('/Users/Dboy/Documents/Stanny/Rajagopal/github_scripts/SG2_true_branch_list.csv',...
%     0,0, data_limits);
% %% Vmag data 
% data_limits = 'W10..KH525610'
% % 
% node_volt_matrix2 = csvread('/Users/Dboy/Downloads/SG2_data_solar_1min.csv',...
%     9,22, data_limits);

% load('/Users/Dboy/Downloads/Node123_randPF.mat')
% true_branch_data = squeeze(mpc_base.branch(2:end,1:2));
% node_volt_matrix2 = v_vec(:,2:end);
%% Remove redundancies
collapse_data = @collapse_redundant_data;
[node_volt_matrix2, true_branch_data] = ...
    collapse_data(node_volt_matrix2, true_branch_data);
%% Remove Redundant Branches
% remove_useless_branches = @remove_redundant_branches;
% true_branch_data = remove_useless_branches(true_branch_data);

% load('/Users/Dboy/Documents/Stanny/Rajagopal/LV_data/MV_urban.mat')
% node_volt_matrix2 = v_vec(:,1:end-2);
%%
take_deriv = @consider_derivative;
node_volt_matrix2 = take_deriv(node_volt_matrix2);

%% 
KL_sum_vec = zeros(numel(node_volt_matrix2(1,:)),1);

for j = 1:numel(KL_sum_vec);
node = j;
%
[N,edges] = histcounts(node_volt_matrix2(:,node), 1000, 'Normalization', 'pdf');
N = squeeze(N);
edges = squeeze(edges);
x_vals = zeros(numel(N),1); 
for i = 1:numel(edges)-1
    x_vals(i) = (edges(i+1) + edges(i))./2; 
end

%%
%mean(node_volt_matrix2(:,node));
% Plot the histogram data
% hold off
plot(x_vals, N)

%% Plot the gaussian fit, extract the mean, sigma
hold on
mu = mean(node_volt_matrix2(:,node));
sigma = std(node_volt_matrix2(:,node));
% y = min(node_volt_matrix(:,b)):0.00001: ...
%     max(node_volt_matrix(:,b));
y = x_vals(:,1);
f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(y,f,'LineWidth',2.5)
%%
xlabel('Change in Voltage Magnitude (V)')
ylabel('Probability Density')
set(gca,'FontSize',18);
legend('histogram', 'Gaussian approx.')
%%
% Calculate the DL divergence
KL_sum = 0;
for i = 1:numel(y)
    if (N(i) > 0 ) && (f(i) > 1E-3) 
        KL_sum = N(i)*log2(N(i)/f(i)) + KL_sum;
    end
end

KL_sum_vec(j) = KL_sum;
end

%% Find the node with the most divergence
KL_stats = zeros(1,4);
KL_stats(1) = max(KL_sum_vec);
KL_stats(2) = min(KL_sum_vec);
KL_stats(3) = mean(KL_sum_vec);
KL_stats(4) = std(KL_sum_vec);

