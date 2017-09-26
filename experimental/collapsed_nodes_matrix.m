function collapsed_nodes_matrix = collapsed_nodes_matrix(...
    node_volt_matrix)

num_buses = numel(node_volt_matrix(1,:));
collapsed_nodes_matrix = zeros(num_buses, num_buses+1);
collapsed_nodes_matrix(:,2) = 1:num_buses;

num_observations = numel(node_volt_matrix(:,1));
outer_node_counter = 1;
node_count_list = 1:(num_buses);
deleted_counter = 0;
while outer_node_counter < numel(node_count_list)
    match_counter = 0;
    inner_node_counter = outer_node_counter +1;
    while inner_node_counter <= numel(node_count_list)

        if (sum(node_volt_matrix(:,node_count_list(outer_node_counter)) ...
                == (node_volt_matrix(:, ...
                node_count_list(inner_node_counter)))) ...
                == num_observations)
            % Remove this node from the count list, to avoid double
            % counting.

            match_counter = match_counter +1;
            %deleted_counter = deleted_counter +1;
            collapsed_nodes_matrix(node_count_list(outer_node_counter)...
                ,match_counter+2) = node_count_list(inner_node_counter);
            node_count_list(inner_node_counter) = [];
        
        else
            inner_node_counter = inner_node_counter +1;
        end
    end
    collapsed_nodes_matrix(node_count_list(outer_node_counter),1)= ...
        match_counter;
    outer_node_counter = outer_node_counter +1;
end
