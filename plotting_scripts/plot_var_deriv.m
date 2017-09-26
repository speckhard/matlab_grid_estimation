% Plot Variable Deriv Step vs SDR

%% Plot Regular SDR
var_deriv = [1 5 15 30 60];
sdr_mat_g = SG1results.sdr_mat(1,:); 
sdr_mat_j = SG1results.sdr_mat(2,:); 
sdr_mat_d = SG1results.sdr_mat(3,:); 

ax1 = subplot(2,2,1)

plot(var_deriv, sdr_mat_g, '--s', var_deriv, sdr_mat_j, '-.o', ...
    var_deriv, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',12);
xlabel('Derivative Step Length (mins)')
ylabel('SDR (%)')
legend('Gaussian','JVHW','Discrete')
title('SG2')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southwest')
%% Plot the SG1solar data 
var_deriv = [1 5 15 30 60];
sdr_mat_g = SG1solarresults.sdr_mat(1,:); 
sdr_mat_j = SG1solarresults.sdr_mat(2,:); 
sdr_mat_d = SG1solarresults.sdr_mat(3,:); 

ax2 = subplot(2,2,2)

plot(var_deriv, sdr_mat_g, '--s', var_deriv, sdr_mat_j, '-.o', ...
    var_deriv, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',12);
xlabel('Derivative Step Length (mins)')
ylabel('SDR (%)')
legend('Gaussian','JVHW','Discrete')
title('SG2-solar')
%% Plot Leaf Node SDR for Variable Deriv Step - SG1
var_deriv = [1 5 15 30 60];
leaf_sdr_mat_g = SG1results.leaf_sdr_mat(1,:); 
leaf_sdr_mat_j = SG1results.leaf_sdr_mat(2,:); 
leaf_sdr_mat_d = SG1results.leaf_sdr_mat(3,:); 

ax3 = subplot(2,2,3)
plot(var_deriv, leaf_sdr_mat_g, '--s', var_deriv, leaf_sdr_mat_j, '-.o', ...
    var_deriv, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',12);
xlabel('Derivative Step Length (mins)')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'northeast')
%legend('boxoff')
%% Leaf SDR for Solar Data
var_deriv = [1 5 15 30 60];
leaf_sdr_mat_g = SG1solarresults.leaf_sdr_mat(1,:); 
leaf_sdr_mat_j = SG1solarresults.leaf_sdr_mat(2,:); 
leaf_sdr_mat_d = SG1solarresults.leaf_sdr_mat(3,:); 

ax4 = subplot(2,2,4)
plot(var_deriv, leaf_sdr_mat_g, '--s', var_deriv, leaf_sdr_mat_j, '-.o', ...
    var_deriv, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',12);
xlabel('Derivative Step Length (mins)')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'northeast')
%legend('boxoff')

%% Link Axes in Plots
linkaxes([ax1,ax2],'xy')
linkaxes([ax3,ax4],'xy')