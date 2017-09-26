%% Plot Dsample Method vs SDR for SG1
subplot(1,2,1)
res_vec = [5 15 30 60];
sdr_mat_g = squeeze(SG1results.leaf_sdr_mat(1,:,:)); 
sdr_mat_j = squeeze(SG1results.leaf_sdr_mat(2,:,:)); 
sdr_mat_d = squeeze(SG1results.leaf_sdr_mat(3,:,:));

plot(res_vec, sdr_mat_g(:,1), ':o', res_vec, sdr_mat_g(:,2), ':+', ...
    res_vec, sdr_mat_g(:,3), ':*', res_vec, sdr_mat_g(:,4),':s', ...
    res_vec, sdr_mat_g(:,5),':x',res_vec, sdr_mat_g(:,6), ':d',...
    'LineWidth', 1.5,'markers',15) 

set(gca,'FontSize',13);
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
legend({'first','mean','median','95th','max','min'}, 'Location', ...
    'northeast')
title('SG2')

%% Plot Dsample Method vs SDR for SG1-solar
subplot(1,2,2)
res_vec = [5 15 30 60];
sdr_mat_g = squeeze(SG1solarresults.leaf_sdr_mat(1,:,:)); 
sdr_mat_j = squeeze(SG1solarresults.leaf_sdr_mat(2,:,:)); 
sdr_mat_d = squeeze(SG1solarresults.leaf_sdr_mat(3,:,:));

plot(res_vec, sdr_mat_g(:,1), ':o', res_vec, sdr_mat_g(:,2), ':+', ...
    res_vec, sdr_mat_g(:,3), ':*', res_vec, sdr_mat_g(:,4),':s', ...
    res_vec, sdr_mat_g(:,5),':x',res_vec, sdr_mat_g(:,6), ':d',...
    'LineWidth', 1.5,'markers',15) 

set(gca,'FontSize',13);
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
legend({'first','mean','median','95th','max','min'}, 'Location', ...
    'northeast')
title('SG2-solar')

