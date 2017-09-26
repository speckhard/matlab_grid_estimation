%% Plot the Resolution vs SDR for SG and SG solar datasets
resolution_vec = [1 15 60] ;

%% Plot SG data
plot(resolution_vec, res_matSG2(1,:), '-.r+', ...
    resolution_vec, res_matSG2(2,:), ':bo',...
    resolution_vec, res_matSG2(3,:), '--c*')
xlabel('Data Resolution (minutes per sample)')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')


%% Plot SG-solar data

plot(resolution_vec, sigdigsSGsolarmat(1,:), '-.r+', ...
    resolution_vec, sigdigsSGsolarmat(2,:), ':bo',...
    resolution_vec, sigdigsSGsolarmat(3,:), '--c*')
xlabel('Base Ten Multiplier Before Rounding (log10(10^x))')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')

