function collapsed_nodes_list = collapsed_nodes_list( ...
    node_volt_matrix, MI_matrix, threshold)

num_buses = numel(node_volt_matrix(1,:));
collapsed_nodes_list = zeros(num_buses, 2);

if strcmp(MI_matrix, 'no MI')
    MI_flag = 0;
else
    MI_flag = 1;
end

collapsed_nodes_counter = 0;
% Cycle through all buses in the outer_loop_except the last node, since it
% will only be able to compare to itself
for i = 1:(num_buses - 1);
    for k = (i+1):num_buses
        if MI_flag == 1
            % Check if the MI of the two nodes is greater than the input
            % threshold value. If so, we note these nodes should be
            % collapsed.
            if MI_matrix(k,i) > threshold
                collapsed_nodes_counter = collapsed_nodes_counter +1;
                collapsed_nodes_list(collapsed_nodes_counter,:) = ...
                    [i,k];
            end
        elseif mean(abs(node_volt_matrix(:,i) - ...
                node_volt_matrix(:,k))) < threshold
            
            collapsed_nodes_counter = collapsed_nodes_counter +1;
            collapsed_nodes_list(collapsed_nodes_counter,:) = [i,k];
        end
    end
end

% Remove Zero-Zero Branches
collapsed_nodes_list=collapsed_nodes_list(1:collapsed_nodes_counter,:);

% Now let's remove cycles in this list
weights = 1:collapsed_nodes_counter;
G = graph(collapsed_nodes_list(:,1),collapsed_nodes_list(:,2),weights);
[T,pred] = minspantree(G,'Method','sparse','Type','forest');

collapsed_nodes_list = T.Edges.EndNodes;

            
                
            