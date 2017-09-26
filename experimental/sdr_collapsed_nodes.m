function [sdr_true_predictions, sdr_total] = sdr_collapsed_nodes(collapsed_nodes_matrix, ...
    collapsed_nodes_list)

num_predicted_collapsed_nodes = sum(collapsed_nodes_matrix(:,1));
num_total_collapsed_nodes = numel(collapsed_nodes_list(:,1));
row_counter = 1;
collapsed_counter=0;
num_rows = numel(collapsed_nodes_matrix(:,1));
while row_counter < num_rows
    num_collapsed_nodes = collapsed_nodes_matrix(row_counter,1);
    for i  = 1:(num_collapsed_nodes)
        for j = (i+1):(num_collapsed_nodes+1)
            % Check if there's a match between the collapsed_nodes_matrix
            % and the collapsed_nodes_list. If any pair of nodes in the
            % matrix row is in the collapsed_nodes_list (excluding
            % permutations, 3,2 should never be in the
            % collapsed_nodes_list);
            
            % Add One to indices since the first value on the row is the
            % number of nodes in this collapsed cluster.
            [collapsed_nodes_matrix(row_counter,i+1),...
                collapsed_nodes_matrix(row_counter,j+1)];
            if ismember([collapsed_nodes_matrix(row_counter,i+1),...
                    collapsed_nodes_matrix(row_counter,j+1)],...
                collapsed_nodes_list,'rows')
                collapsed_counter = collapsed_counter + 1;
            end
        end 
    end
    row_counter = row_counter +1;
end

sdr_true_predictions = collapsed_counter/num_predicted_collapsed_nodes;
sdr_total = collapsed_counter/num_total_collapsed_nodes;

    
    
    