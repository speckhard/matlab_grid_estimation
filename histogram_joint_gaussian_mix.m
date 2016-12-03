% Joint Probability Mixed Gaussian Generation

% SG2
% node_volt_matrix = SG2datavolt15min(:,1:272);

% SG1
node_volt_matrix = SGdatanodevolt(:,1:52);

%% Plot The Joint Histogram
hold off
node1 =9;
node2 = 12;

[N,v] = hist3([node_volt_matrix(:,node1),node_volt_matrix(:,node2)],...
    [50,50]);

c = cell2mat(v);
surf(c(1:50),c(51:100),N)
%contour(N)
grid on
colormap(hot)
title('Contour plot of P(Vmag(Node 9), Vmag(Node12)) for 100x100 bin matrix')

%% Plot the k = 4 gaussian mix of the data

joint_data = [node_volt_matrix(:,node1), node_volt_matrix(:,node2)];
GMModel = fitgmdist(joint_data,4);
dimension_1 = min(node_volt_matrix(:,node1)):1: ...
    max(node_volt_matrix(:,node1));
dimension_2 = min(node_volt_matrix(:,node2)):1: ...
    max(node_volt_matrix(:,node2));

%%
max_node1 = max(max(node_volt_matrix(:,node1)))
min_node1 = min(min(node_volt_matrix(:,node1)));
gmm = gmdistribution(GMModel.mu,GMModel.Sigma, GMModel.ComponentProportion)
ezsurfc(@(x,y) pdf(gmm,[x y]), [max_node1, min_node1], 50);
%%
hold off
ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]),[max_node1, min_node1],500)
%%
surf(dimension_1, dimension_2,pdf(GMModel,[dimension_1 dimension_2]))
title('{\bf Scatter Plot and Fitted Gaussian Mixture Contours}')
%legend(h,'Model 0','Model1')
hold off

%% 
mu = mean(node_volt_matrix(:,b))
sigma = std(node_volt_matrix(:,b))
y = min(node_volt_matrix(:,b)):1: ...
    max(node_volt_matrix(:,b));