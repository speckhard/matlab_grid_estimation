% This file improves upon mutual_information_computation_10_7_16
% by making use of individual functions in the computation.

%% first let's find out what nodes exist in the data set

number_of_buses = numel(SGdatanodevolt(1,:));

%let's make a vector of possible nodes, 1:number_of_buses
possible_nodes_vec = linspace(1,number_of_buses,number_of_buses);

%search true branch list for nodes
i = 1;
while i < 1:numel(possible_nodes_vec)
    if  ismember(possible_nodes_vec(i),SandiaNationalLabTrueNodeData)
        possible_nodes_vec(i) = [];
    else
        i = i +1;
    end
end

if numel(possible_nodes_vec) ~= number_of_buses
    disp('some buses are missing')
end



%% Find the entropy of each node, H(i).
tic
find_single_node_entropy = @single_node_entropy_vmag_only;
single_node_entropy_vec = find_single_node_entropy(SGdatanodevolt);
disp('time required to find entropy')
toc

%% Find the joint entropy of pairs of different nodes, H(i,j).
tic 
find_joint_entropy = @joint_entropy_vmag_only_real;
joint_entropy_matrix = find_joint_entropy(SGdatanodevolt);
disp('time required to find joint entropy')
toc

%% Find the mutual information of pairs of different nodes, I(i,j).
tic
find_mutual_information = @mutual_information;
mutual_information_matrix = find_mutual_information(...
    single_node_entropy_vec, joint_entropy_matrix);
disp('time required to find mutual information')
toc

%% Sort the mutual information values into descending pairs of nodes.
tic
sort_mutual_information = @sort_MI;
sorted_MI_nodes = sort_mutual_information(mutual_information_matrix);
disp('time required to sort mutual information')
toc
%% Find maximum weight spanning tree.
tic
find_valid_branches = @find_branches;
%number_of_buses = numel(SGdatanodevolt(1,1:52));
valid_branch_node_pairs = find_branches(sorted_MI_nodes, number_of_buses);
disp('time required to find valid branches')
toc

% Graph the tree.
tic
G = graph(valid_branch_node_pairs(:,1),valid_branch_node_pairs(:,2));

% the default nodelables are too small to read in the 123 node grid
% we erase them and add them again with font size 7. 
% This is a workaround for the lack of nodelabel.fontsize obj property
% in node graphs in matlab.
h = plot(G, 'NodeLabel', []);

for i=1:length(h.XData)
text(h.XData(i),h.YData(i),num2str(i),'fontsize',14);
end

disp('time reuqired to graph data')
toc

%% Find the SDR.
tic
% this is our succesful detection counter, it is incremented if we can
% find a match between our valid_pairs_of_nodes and the real branches in
% the grid, mpc_base.branch(:,1:2).
sdr_counter = 0 ;


% Here we should consider ordering the valid branches so that the smaller
% branch node is always on the left hand side (LHS). Instead, here we check
% for both possibilities, changing the valid branch node pairs ordering
% in case a match isn't found.

for i = 1:(number_of_buses-1)
    
    % note we subtract the ones vector since mpc_base.branch's 
    % numbering is off by one (it includes the slack bus).
    if (ismember(valid_branch_node_pairs(i,:), ...
            SandiaNationalLabTrueNodeData,'rows'))
        sdr_counter = sdr_counter +1;
    elseif (ismember([valid_branch_node_pairs(i,2), ... 
            valid_branch_node_pairs(i,1)], SandiaNationalLabTrueNodeData...
            ,'rows'))
        sdr_counter = sdr_counter +1;
    end
    
end

disp('time required to find the succesful detection rate')
toc
% disp('number of valid branches');
% sdr_counter;
disp('percentage of valid branches')
sdr_counter/(number_of_buses-1)*100



