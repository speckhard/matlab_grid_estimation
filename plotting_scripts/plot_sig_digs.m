% Plot Variable Deriv Step vs SDR

%% Plot Regular SDR - SG
sig_digs = [1E0 1E-1 1E-2 1E-3 1E-4 1E-5];
sdr_mat_g = SG1results.sdr_mat(1,1:end-4); 
sdr_mat_j = SG1results.sdr_mat(2,1:end-4); 
sdr_mat_d = SG1results.sdr_mat(3,1:end-4); 
ax1 = subplot(2,2,1)

semilogx(sig_digs, sdr_mat_g, '--s', sig_digs, sdr_mat_j, '-.o', ...
    sig_digs, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Voltage Magnitude Precision (V)')
ylabel('SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southwest')
title('SG2')
set(gca,'FontSize',12);
%% Plot Regular SDR - SGsolar

sdr_mat_g = SG1solarresults.sdr_mat(1,:); 
sdr_mat_j = SG1solarresults.sdr_mat(2,:); 
sdr_mat_d = SG1solarresults.sdr_mat(3,:); 
ax2 = subplot(2,2,2)

semilogx(sig_digs, sdr_mat_g, '--s', sig_digs, sdr_mat_j, '-.o', ...
    sig_digs, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Voltage Magnitude Precision (V)')
ylabel('SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southwest')
title('SG2-solar')
set(gca,'FontSize',12);
%% Plot Leaf Node SDR for Variable Deriv STep -SG

leaf_sdr_mat_g = SG1results.leaf_sdr_mat(1,1:end-4); 
leaf_sdr_mat_j = SG1results.leaf_sdr_mat(2,1:end-4); 
leaf_sdr_mat_d = SG1results.leaf_sdr_mat(3,1:end-4); 
ax3 = subplot(2,2,3)

semilogx(sig_digs, leaf_sdr_mat_g, '--s', sig_digs, leaf_sdr_mat_j, '-.o', ...
    sig_digs, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Voltage Magnitude Precision (V)')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southwest')
set(gca,'FontSize',12);

%% Leaf SDR -SGsolar

leaf_sdr_mat_g = SG1solarresults.leaf_sdr_mat(1,:); 
leaf_sdr_mat_j = SG1solarresults.leaf_sdr_mat(2,:); 
leaf_sdr_mat_d = SG1solarresults.leaf_sdr_mat(3,:); 
ax3 = subplot(2,2,4)

semilogx(sig_digs, leaf_sdr_mat_g, '--s', sig_digs, leaf_sdr_mat_j, '-.o', ...
    sig_digs, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
xlabel('Voltage Magnitude Precision (V)')
ylabel('Leaf SDR (%)')
legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southwest')
set(gca,'FontSize',12);
%% Link Axes
linkaxes([ax1,ax2],'xy')
linkaxes([ax3,ax4],'xy')
