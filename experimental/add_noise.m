function node_volt_matrix = add_noise(node_volt_matrix, ...
    noise_type, percent_noise);

percent_change = percent_noise;

num_nodes = numel(node_volt_matrix(1,:));

num_observations = numel(node_volt_matrix(:,1));
if strcmp(noise_type,'node_specific_min_max')
    local_minmax_flag =1 ;
else
    local_minmax_flag =0;
end


for i = 1:num_nodes
    if local_minmax_flag ==1
        min_rand = min(node_volt_matrix(:,i));
        max_rand = max(node_volt_matrix(:,i));
        size(max_rand);
    end
%     %min-maxx
%     node_volt_matrix(:,i) = node_volt_matrix(:,i) + ...
%         (max_rand-min_rand)*2*(rand(num_observations,1)-0.5)*percent_change;
%     
%     %local mean
    node_volt_matrix(:,i) = node_volt_matrix(:,i) + ...
        mean(node_volt_matrix(:,i))*2*...
        (rand(num_observations,1)-0.5)*percent_change;
end

    
