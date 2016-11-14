% This file improves upon mutual_information_computation_10_7_16
% by making use of individual functions in the computation.


%% first let's find out what nodes exist in the data set

number_of_buses = numel(SGdatanodevolt(1,:));

%let's make a vector of possible nodes, 1:number_of_buses
possible_nodes_vec = linspace(1,number_of_buses,number_of_buses);

%search true branch list for nodes
i = 1;
while i < numel(possible_nodes_vec)
    if  ismember(possible_nodes_vec(i),SandiaNationalLabTrueNodeData)
        possible_nodes_vec(i) = [];
    else
        i = i +1;
    end
end

if numel(possible_nodes_vec) ~= number_of_buses
    disp('some buses are missing')
end

%% Let's Check for Identical Nodes
% See if nodes are the same by checking if all the measuremnts are the same

% first, copy data from sandia node volt matrix into a new matrix
Node_Volt_Matrix = SGdatanodevolt1;
% Second, copy the list of true branches
tic
True_Branch_Data = SandiaNationalLabTrueNodeData;

number_observations = numel(Node_Volt_Matrix(:,1));

number_identical_nodes = 0;
% Note the number of columns (i.e. nodes) is changing, this means we need to
% evaluate this number every loop of the cycle.

% we have to use a while loop since for loops evaluate bounds at first run
% and we will change the size of our matrix that we iterate through, since
% we find identical pairs, we'll remove columns. 
i = 1;

matrix_of_identical_nodes = zeros(numel(True_Branch_Data(:,1)), ...
    numel(True_Branch_Data(1,:)));

while i < numel(Node_Volt_Matrix(1,:))
    % we dont want to evaluate whether one node is the same as another
    % column so we check starting with node i+1
    % re-intialize k
    k = i + 1; 
    while k <= numel(Node_Volt_Matrix(1,:))
        
        % check whether it is the same node
        if (sum(Node_Volt_Matrix(:,i) ...
                == Node_Volt_Matrix(:,k)) == number_observations)
            
            number_identical_nodes = number_identical_nodes + 1;
            matrix_of_identical_nodes(number_identical_nodes, :) = ...
                [i,k];
            % now let's remove the identical node
            %Node_Volt_Matrix(:,k) = ones(number_observations,1)*k;
            Node_Volt_Matrix(:,k) = [];
            
            % change the list of true branches
            % Go through the rows of the true branch data set
            for g = 1:numel(True_Branch_Data(:,1))
                % check if we find the second identical node-k in the row
                for h = 1:numel(True_Branch_Data(1,:))
                    if True_Branch_Data(g,h) == k
                        True_Branch_Data(g,h) = i;
                    elseif True_Branch_Data(g,h) > k
                    % since I've just deleted a col, I also need to
                    % downshift all the values in the True Branch Data set 
                    % that were above this col. Ex. if i delete column 5 
                    % (node 5), i need to make nodes 6 appear as node 5 in 
                    % the true branch data
                        True_Branch_Data(g,h) = True_Branch_Data(g,h) -1;
                    end
                end
            end
        %end
        else
        % if a column was not deleted continue iterating. We dont increment
        % iterator if a col was deleted since now col k is a different col
            k = k +1;
        end
    end
    i = i + 1;
end

disp('time to check for identical nodes')
toc
  
%% remove true branches that are self-referring
tic
branch_counter = 1;
while branch_counter < numel(True_Branch_Data(:,1))
    if True_Branch_Data(branch_counter, 1) == ...
            True_Branch_Data(branch_counter,2)
        True_Branch_Data(branch_counter, :) = [];
    else
        branch_counter = branch_counter + 1;
    end
end
disp('time to delete self-referring nodes')
toc

%% fix the matrix of identical nodes for post-analytical purposes
% the matrix of idenitcal nodes does not have the correct numbering for
% for analytical purposes, since each time a identical node is found
% the numbering is downshifted for nodes above the deleted nodes

for i = 2:numel(matrix_of_identical_nodes(:,1))
    matrix_of_identical_nodes(i,2) = ...
        matrix_of_identical_nodes(i,2) + (i-1);
end


%% Find the entropy of each node, H(i).
tic
find_single_node_entropy = @single_node_entropy_vmag_only;
single_node_entropy_vec = find_single_node_entropy(Node_Volt_Matrix);
disp('time required to find entropy')
toc

%% Find the joint entropy of pairs of different nodes, H(i,j).
tic 
find_joint_entropy = @joint_entropy_vmag_only_fixed_neglog;
joint_entropy_matrix = find_joint_entropy(Node_Volt_Matrix);
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
sort_mutual_information = @sort_MI_displays_sorting;
sorted_MI_nodes = sort_mutual_information(mutual_information_matrix);
disp('time required to sort mutual information')
toc

%% Find maximum weight spanning tree.
tic
find_valid_branches = @find_branches;
number_of_buses = numel(Node_Volt_Matrix(1,:));
valid_branch_node_pairs = find_branches(sorted_MI_nodes, number_of_buses);
disp('time required to find valid branches')
toc

%% Graph the tree.
tic
hold on
G = graph(valid_branch_node_pairs(:,1),valid_branch_node_pairs(:,2));

% the default nodelables are too small to read in the 123 node grid
% we erase them and add them again with font size 7. 
% This is a workaround for the lack of nodelabel.fontsize obj property
% in node graphs in matlab.
h = plot(G, 'NodeLabel', []);

for i=1:length(h.XData)
text(h.XData(i),h.YData(i),num2str(i),'fontsize',18);
end

disp('time reuqired to graph data')
toc

%% Graph the True Node Data
tic
G = graph(True_Branch_Data(:,1),True_Branch_Data(:,2));

% the default nodelables are too small to read in the 123 node grid
% we erase them and add them again with font size 7. 
% This is a workaround for the lack of nodelabel.fontsize obj property
% in node graphs in matlab.
h = plot(G, 'NodeLabel', []);

for i=1:length(h.XData)
text(h.XData(i),h.YData(i),num2str(i),'fontsize',18);
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
            True_Branch_Data,'rows'))
        sdr_counter = sdr_counter +1;
    elseif (ismember([valid_branch_node_pairs(i,2), ... 
            valid_branch_node_pairs(i,1)], True_Branch_Data...
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



