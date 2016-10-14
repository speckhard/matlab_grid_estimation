% This function computes the real and imaginary portions of
% the voltage measurements. It combines this data into a three 
% dimenstional array (real/imaginary, observation number, bus number)
% of size ( 2, number of buses, number of observations).

function v_clean_matrix = measurement_cleaner(v_vec, theta_vec)

% the function takes as input:
% v_vec: voltage magnitude data
% v_theta: voltage angle dat

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

% my 3d matrix, row determines real or imag, ...
% column is observation, and 3rd dimension determines which bus
v_clean_matrix = zeros(number_of_observations, 2, number_of_buses) ;

for i = 1:number_of_buses %% loop between the different busses
    
    % assign the real part of V
    %cos(theta_vec_without_slack(:,i)*pi/180)...
    v_clean_matrix(:,1,i) = ... 
        v_vec_without_slack(:,i); 
    % assign the imaginary part of V
    %sin(theta_vec_without_slack(:,i)*pi/180)
    v_clean_matrix(:,2,i) =  ...
        v_vec_without_slack(:,i);
        
end