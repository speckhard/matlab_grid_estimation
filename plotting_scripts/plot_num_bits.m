% Plot Variable Deriv Step vs SDR

%% Plot Regular SDR - SG
num_bits = [4 6 8 10 12 14 16];
sdr_mat_g = SG1results.mean_sdr_mat(1,:); 
sdr_mat_j = SG1results.mean_sdr_mat(2,:); 
sdr_mat_d = SG1results.mean_sdr_mat(3,:); 
%%
ax1 = subplot(2,2,1)
plot(num_bits, sdr_mat_g, '--s', num_bits, sdr_mat_j, '-.o', ...
    num_bits, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Number of Bits of Voltage Data')
ylabel('SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
title('SG2')
set(gca,'FontSize',12);

%% Plot Regular SDR - SG1solar
num_bits = [4 6 8 10 12 14 16];
sdr_mat_g = SG1solarresults.sdr_mat(1,:); 
sdr_mat_j = SG1solarresults.sdr_mat(2,:); 
sdr_mat_d = SG1solarresults.sdr_mat(3,:); 
% sdr_mat_g = SG1solarresults.mean_sdr_mat(1,:); 
% sdr_mat_j = SG1solarresults.mean_sdr_mat(2,:); 
% sdr_mat_d = SG1solarresults.mean_sdr_mat(3,:); 

ax2 = subplot(2,2,2)
plot(num_bits, sdr_mat_g, '--s', num_bits, sdr_mat_j, '-.o', ...
    num_bits, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Number of Bits for Voltage Mag.')
ylabel('SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
title('SG2-solar')
set(gca,'FontSize',12);
%% Plot Leaf Node SDR for - SG1

leaf_sdr_mat_g = SG1results.mean_leaf_sdr_mat(1,:); 
leaf_sdr_mat_j = SG1results.mean_leaf_sdr_mat(2,:); 
leaf_sdr_mat_d = SG1results.mean_leaf_sdr_mat(3,:); 
ax3 = subplot(2,2,3)
plot(num_bits, leaf_sdr_mat_g, '--s', num_bits, leaf_sdr_mat_j, '-.o', ...
    num_bits, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Number of Bits for Voltage Mag.')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
set(gca,'FontSize',12);

%% Plot Leaf Node SDR for Variable Deriv STep - SG1solar

leaf_sdr_mat_g = SG1solarresults.leaf_sdr_mat(1,:); 
leaf_sdr_mat_j = SG1solarresults.leaf_sdr_mat(2,:); 
leaf_sdr_mat_d = SG1solarresults.leaf_sdr_mat(3,:); 
ax4 = subplot(2,2,4)
plot(num_bits, leaf_sdr_mat_g, '--s', num_bits, leaf_sdr_mat_j, '-.o', ...
    num_bits, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Number of Bits for Voltage Mag.')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
set(gca,'FontSize',12);
%% Link Axes
linkaxes([ax1,ax2],'xy')
linkaxes([ax4,ax3],'xy')
axis([ax3 ax4],[4 16 70 100])
axis([ax1 ax2],[4 16 70 100])