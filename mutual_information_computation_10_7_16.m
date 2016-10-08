% script to compute mutual information 


% first let's trim the vector v_vec to remove the slack bus
v_vec_without_slack = v_vec; % copy v_vec data into v_vec without slack
% now remove the first column of data, i.e. the slack bus
v_vec_without_slack(:,1) = [];

% first let's similary trim the vector v_theta to remove the slack bus
theta_vec_without_slack = theta_vec; % copy v_vec data into v_vec without slack
% now remove the first column of data, i.e. the slack bus
theta_vec_without_slack(:,1) = [];

% number of buses is a constant let's save it as one
% we use numel function in matlab to find the number of columns in our
% new voltage matrix without the slack bus
number_of_buses = numel(v_vec_without_slack(1,:));

%number of observations is a constant let's save it as one
number_of_observations = numel(v_vec_without_slack(:,1));

% my gaussian 3d matrix, row determines real or imag, ...
% column is observation, and 3rd dimension determines which bus
v_gaussian = zeros(2,number_of_buses, number_of_observations) ;

for i = 1:number_of_buses %% loop between the different busses
    
    % assign the real part of V
    v_gaussian(1,i,:) = cos(theta_vec_without_slack(:,i))...
        .*v_vec_without_slack(:,i); 
    % assign the imaginary part of V
    v_gaussian(2,i,:) = sin(theta_vec_without_slack(:,i)) ...
        .*v_vec_without_slack(:,i);
        
end

%% compute the entropy vector, h(i)
h_entropy = zeros(1,number_of_buses); % intialize the vector

for i=1:number_of_buses
    % note squeeze is required to turn a 3d matrix of size (1,2,8760)
    % like the one we use to calculate the gaussian matrix, into a
    % 2D matrix of size (2,8760) since only 2D matrices can be fed into
    % the matlab function cov()
    h_entropy(i) = number_of_observations*2/2*(1+2*log(2*pi))...
        +0.5*log(det(cov([squeeze(v_gaussian(1,i,:)),...
        squeeze(v_gaussian(2,i,:))])));
end

%% now let's compute the joint entropy
h_joint_entropy = zeros(number_of_buses,number_of_buses);

for i=1:number_of_buses
    for k=1:number_of_buses
        if k == i % we don't care about h(1,1) since we don't use it
            % in mutual information calculations
            h_joint_entropy(k,i) = 0;
        else 
            h_joint_entropy(i,k) = number_of_observations*4/2*(1+2*log(2*pi))...
                +0.5*log(det(cov([squeeze(v_gaussian(1,i,:)), ...
                squeeze(v_gaussian(2,i,:)), squeeze(v_gaussian(1,k,:)),...
                squeeze(v_gaussian(2,k,:))])));
        end
    end
end

%% now let's compute the mutual information

mutual_information = zeros(number_of_buses,number_of_buses);

for i=1:number_of_buses
    for k=1:i
        if i == k % this is the self-information
            mutual_information(i,k) = 0;
        else
            mutual_information(i,k) = h_entropy(i)+h_entropy(k)...
                -h_joint_entropy(i,k);
        end
    end
end
                                                                                                         
%% Sort the Mutual Information into a matrix


% since we're looking for a second-order probability distributions
% and we assume bus 1 (i.e. bus 2 from the original data) in the data set
% without the slack bus is connected to the slack bus, we can tell
% the maximum number of connections
max_number_of_connections = number_of_buses - 1;

% column vector of the unsorted_mutual_information spotted is initialized to zero
unsorted_mutual_information = zeros((number_of_buses-1)*number_of_buses/2,1);
index_for_sorting = 1;

for i = 2:number_of_buses
    for k = 1:(i-1)
        unsorted_mutual_information(index_for_sorting) = mutual_information(i,k);
        index_for_sorting = index_for_sorting+1;
        
    end
end

% now sort the sorted_mutual_information
sorted_mutual_information = sort(unsorted_mutual_information,'descend');

% now create a matrix with the pairs of nodes corresponding to sorted
% mutual information

sorted_pairs_of_nodes = zeros(numel(sorted_mutual_information), 2);

for i = 1:numel(sorted_mutual_information)
    [r,c]=find(mutual_information== sorted_mutual_information(i));
    
    number_of_identical_mutual_information_vals = numel(r);
    if number_of_identical_mutual_information_vals == 1;
        sorted_pairs_of_nodes(i,:) = [r,c];
    else 
        for k = 1:number_of_identical_mutual_information_vals;
           sorted_pairs_of_nodes(i+k,:) = [r(k), c(k)];
        end
   % increment the iteration variable i by num of identical
   % mutual information vals so we can move on to the next mi val
   i = i + number_of_identical_mutual_information_vals;
    end
end

%% now we need to select the maximum weight spanning tree
% we select the set of nodes with the maximum mutual information
% so long as adding a set of nodes does not create a cycle in our 
% undirected graph

% recall number of max connections is the number of buses - 1 
% since we are looking for a tree graph, i.e. 2nd order prob fxn
valid_pairs_of_nodes = zeros(max_number_of_connections,2);

% the first sorted pair of nodes is our starting point
valid_pairs_of_nodes(1,:) = sorted_pairs_of_nodes(1,:);
valid_pairs_count = 1;

ccs = @cycle_check_start;
cc = @cycle_check;

for i = 2:numel(sorted_pairs_of_nodes)
    start_flag = ccs(sorted_pairs_of_nodes(i,1),...
        sorted_pairs_of_nodes(i,2), valid_pairs_of_nodes);
    
    if cc(sorted_pairs_of_nodes(i,1),...
        sorted_pairs_of_nodes(i,2), start_flag, ...
        valid_pairs_of_nodes,[1,1]) == 0
        
        valid_pairs_count = valid_pairs_count +1
        valid_pairs_of_nodes(valid_pairs_count,:) = sorted_pairs_of_nodes(i,:);
        
    else 
        disp('cycle detected')
    end
    
    if valid_pairs_count == number_of_buses - 1
        break
    end
end

    
    
%% Graph the results    
    

G = graph(valid_pairs_of_nodes(:,1),valid_pairs_of_nodes(:,2));
plot(G)
        
        






        


