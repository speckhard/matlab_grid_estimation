%% Plot the Resolution vs SDR for SG and SG solar datasets

res_vec = [1 5 15 30 60];

%% Plot SG data
plot(res_vec, ResvsSDRSGvec(1,:), '-.r+', ...
    res_vec, ResvsSDRSGvec(2,:), ':bo',...
    res_vec, ResvsSDRSGvec(3,:), '--c*')
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')


%% Plot SG-solar data

plot(res_vec, ResvsSDRSGsolarvec(1,:), '-.r+', ...
    res_vec, ResvsSDRSGsolarvec(2,:), ':bo',...
    res_vec, ResvsSDRSGsolarvec(3,:), '--c*')
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')
