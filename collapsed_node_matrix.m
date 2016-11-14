function collapsed_node_matrix = collapsed_nodes_matrix(...
    node_volt_matrix, mutual_information_flag, threshold);

num_buses = numel(node_volt_matrix(1,:));
collapsed_nodes_matrix = zeros(num_buses, num_buses+1);
collapsed_nodes_matrix(:,2) = 1:num_buses;

if strcmp(MI_matrix, 'no MI')
    MI_flag = 0;
else
    MI_flag = 1;
end

for i = 1:(num_buses - 1);
    row_counter = 0;
    for k = (i+1):num_buses
        if MI_flag == 1
            % Check if the MI of the two nodes is greater than the input
            % threshold value. If so, we note these nodes should be
            % collapsed.
            if MI_matrix(k,i) > threshold
                row_counter = row_counter +1;
                % Start adding values on the third row
                collapsed_nodes_matrix(i,row_counter+2) = k;
            end
        elseif mean(abs(node_volt_matrix(:,i) - ...
                node_volt_matrix(:,k))) < threshold
            
            row_counter = row_counter +1;
            collapsed_nodes_matrix(i,row_counter+2) = k;
        end
    end
    collapsed_nodes_matrix(i,1)= row_counter;
end
