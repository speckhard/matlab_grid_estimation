% Plot Vary Deriv Step Size Results

% First plot SG data

step_size = [1,2,5,10,15,20,30,40,50,60]
plot(step_size,varyderiv_sg_sdr_mat(1,:), 'r+:')
hold on
plot(step_size, varyderiv_sg_sdr_mat(2,:),'bo--')
plot(step_size,varyderiv_sg_sdr_mat(3,:),'m*-.')
title('Derivative Step Size vs. SDR, SGdatanodevolt')
xlabel('Derivative step size (minutes)')
ylabel('SDR (%)')
legend('Gaussian', 'JVHW', 'Discrete')

%% Plot SG-solar data
step_size = [2,5,10,15,20,30,40,50,60]
hold off
plot(step_size,varyderiv_sg_solar_sdr_mat(1,:), 'r+:')
hold on
plot(step_size, varyderiv_sg_solar_sdr_mat(2,:),'bo--')
plot(step_size,varyderiv_sg_solar_sdr_mat(3,:),'m*-.')
title('Derivative Step Size vs. SDR, SGdatanodevoltsolar')
xlabel('Derivative step size (minutes)')
ylabel('SDR (%)')
legend('Gaussian', 'JVHW', 'Discrete')