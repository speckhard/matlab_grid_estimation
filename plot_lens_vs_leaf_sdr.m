%% Plot Lens Vs SDR

% Plot Lens vs Res vs SDR
lens_vec = [1 4 7 14 30 60 90 180 364];
res_vec = [1 5 15 30 60];

% Gaussian data
sdr_mat_g = SG1results.leaf_mean_sdr(1,1:(end),1);
std_sdr_mat_g = SG1results.leaf_std_sdr(1,1:(end),1);

% JVHW data
sdr_mat_j = SG1results.leaf_mean_sdr(1,1:(end),2);
std_sdr_mat_j = SG1results.leaf_std_sdr(1,1:(end),2);

% Discrete data
sdr_mat_d = SG1results.leaf_mean_sdr(1,1:(end),3);
std_sdr_mat_d = SG1results.leaf_std_sdr(1,1:(end),3);


%% Regular SDR Plot SG1 - Lens
figure(1)
ax1 =subplot(3,2,1)
errorbar(lens_vec, sdr_mat_g, std_sdr_mat_g,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
set(gca,'FontSize',12);
legend({'Gaussian'}, 'Location', 'southeast')
title('SG2')

ax3 = subplot(3,2,3)
errorbar(lens_vec, sdr_mat_j, std_sdr_mat_j,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
set(gca,'FontSize',12);
legend({'JVHW'}, 'Location', 'northeast')

ax5 = subplot(3,2,5)
errorbar(lens_vec, sdr_mat_d, std_sdr_mat_d,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
%title('Discrete MI Method')
set(gca,'FontSize',12);
legend({'Discrete'}, 'Location', 'southeast')

%% SG1 -solar plots
% Gaussian data
sdr_mat_g = SG1solarresults.leaf_mean_sdr(1,1:(end),1);
std_sdr_mat_g = SG1solarresults.leaf_std_sdr(1,1:(end),1);

% JVHW data
sdr_mat_j = SG1solarresults.leaf_mean_sdr(1,1:(end),2);
std_sdr_mat_j = SG1solarresults.leaf_std_sdr(1,1:(end),2);


% Discrete data
sdr_mat_d = SG1solarresults.leaf_mean_sdr(1,1:(end),3);
std_sdr_mat_d = SG1solarresults.leaf_std_sdr(1,1:(end),3);

ax2 =subplot(3,2,2)
errorbar(lens_vec, sdr_mat_g, std_sdr_mat_g,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
title('SG2-solar')
set(gca,'FontSize',12);
legend({'Gaussian'}, 'Location', 'northeast')

ax4 = subplot(3,2,4)
errorbar(lens_vec, sdr_mat_j, std_sdr_mat_j,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
set(gca,'FontSize',12);
legend({'JVHW'}, 'Location', 'southeast')

ax6 = subplot(3,2,6)
errorbar(lens_vec, sdr_mat_d, std_sdr_mat_d,'--o', 'LineWidth', 1.5,...
    'markers',15)
xlabel('Lens of Data (days)')
ylabel('Leaf SDR (%)')
%title('Discrete MI Method')
set(gca,'FontSize',12);
legend({'Discrete'}, 'Location', 'northeast')

%% Link Axes
linkaxes([ax1,ax2],'xy')
linkaxes([ax4,ax3],'xy')
linkaxes([ax5,ax6],'xy')
axis([ax3 ax4],[0 400 80 95])
axis([ax1 ax2],[0 400 80 95])
axis([ax5 ax6],[0 400 75 95])





% %% Leaf SDR Plot
% lens_vec = [1 4 7 14 30 60 90 180 364];
% % Gaussian data
% leaf_sdr_mat_g = results.leaf_mean_sdr(1,1:(end),1);
% leaf_std_mat_g = results.leaf_std_sdr(1,1:(end),1);
% % JVHW data
% leaf_sdr_mat_j = results.leaf_mean_sdr(1,1:(end),2);
% leaf_std_mat_j = results.leaf_std_sdr(1,1:(end),2);
% % Discrete data
% leaf_sdr_mat_d = results.leaf_mean_sdr(1,1:(end),3);
% leaf_std_mat_d = results.leaf_std_sdr(1,1:(end),3);
% figure(1)
% subplot(3,1,1)
% errorbar(lens_vec, leaf_sdr_mat_g, leaf_std_mat_g,'--o', 'LineWidth', 1.5,...
%     'markers',6)
% xlabel('Lens of Data (days)')
% ylabel(':eaf SDR (%)')
% title('Gaussian MI Method')
% subplot(3,1,2)
% errorbar(lens_vec, leaf_sdr_mat_j, leaf_std_mat_j,'--o', 'LineWidth', 1.5,...
%     'markers',6)
% xlabel('Lens of Data (days)')
% ylabel('Leaf SDR (%)')
% title('JVHW MI Method')
% subplot(3,1,3)
% errorbar(lens_vec, leaf_sdr_mat_d, leaf_std_mat_d,'--o', 'LineWidth', 1.5,...
%     'markers',6)
% xlabel('Lens of Data (days)')
% ylabel('Leaf SDR (%)')
% title('Discrete MI Method')
