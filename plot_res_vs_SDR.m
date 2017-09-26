%% Plot Res vs SDR for all MI_methods
lens_vec = [364];
res_vec = [1 5 15 30 60];
sdr_mat_g = SG1results.mean_sdr_mat(:,end,1);
sdr_mat_j = SG1results.mean_sdr_mat(:,end,2);
sdr_mat_d = SG1results.mean_sdr_mat(:,end,3);

std_sdr_mat = SG1results.std_sdr_mat(:,end,3);
leaf_sdr_mat = SG1results.leaf_mean_sdr(:,end,3);
leaf_std_mat = SG1results.leaf_std_sdr(:,end,3);
% two_branch_sdr_mat = SG1results.two_branch_mean_sdr(:,end,3);
% two_branch_std_mat = SG1results.two_branch_std_sdr(:,end,3);
% three_branch_sdr_mat = SG1results.three_branch_mean_sdr(:,end,3);
% three_branch_std_mat = SG1results.three_branch_std_sdr(:,end,3);

figure(1)
ax1=subplot(2,2,1)
plot(res_vec,sdr_mat_g, '--s', res_vec, sdr_mat_j, '-.o', ...
    res_vec, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
% legend('Gaussian', 'JVHW' , 'Discrete')
legend({'Gaussian', 'JVHW' , 'Discrete'},'Location','southwest')
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
set(gca,'FontSize',12);
title('SG2')

%% Plot Res vs SDR for all MI_methods
lens_vec = [364];
res_vec = [1 5 15 30 60];
sdr_mat_g = SG1solarresults.mean_sdr_mat(:,end,1);
sdr_mat_j = SG1solarresults.mean_sdr_mat(:,end,2);
sdr_mat_d = SG1solarresults.mean_sdr_mat(:,end,3);

figure(1)
ax2=subplot(2,2,2)
plot(res_vec,sdr_mat_g, '--s', res_vec, sdr_mat_j, '-.o', ...
    res_vec, sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
% legend('Gaussian', 'JVHW' , 'Discrete')
legend({'Gaussian', 'JVHW' , 'Discrete'},'Location','southwest')
xlabel('Downsampling Resolution (mins)')
ylabel('SDR (%)')
set(gca,'FontSize',12);
title('SG2-solar')
%% Plot Res vs Leaf SDR for all MI_methods for 364 day lens - non-solar
leaf_sdr_mat_g = SG1results.leaf_mean_sdr(:,end,1);
leaf_sdr_mat_j = SG1results.leaf_mean_sdr(:,end,2);
leaf_sdr_mat_d = SG1results.leaf_mean_sdr(:,end,3);

ax3=subplot(2,2,3)
plot(res_vec,leaf_sdr_mat_g, '--s', res_vec, leaf_sdr_mat_j, '-.o', ...
    res_vec, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
legend({'Gaussian', 'JVHW' , 'Discrete'},'Location','southwest')
xlabel('Downsampling Resolution (mins)')
ylabel('Leaf SDR (%)')
set(gca,'FontSize',12);
%% Plot Res vs Leaf SDR for all MI_methods for 364 day lens - solar
leaf_sdr_mat_g = SG1solarresults.leaf_mean_sdr(:,end,1);
leaf_sdr_mat_j = SG1solarresults.leaf_mean_sdr(:,end,2);
leaf_sdr_mat_d = SG1solarresults.leaf_mean_sdr(:,end,3);

ax4=subplot(2,2,4)
plot(res_vec,leaf_sdr_mat_g, '--s', res_vec, leaf_sdr_mat_j, '-.o', ...
    res_vec, leaf_sdr_mat_d, ':d',...
    'LineWidth', 1.5,'markers',15) 
legend({'Gaussian', 'JVHW' , 'Discrete'},'Location','southwest')
xlabel('Downsampling Resolution (mins)')
ylabel('Leaf SDR (%)')
set(gca,'FontSize',12);

%% Control Axes
linkaxes([ax1,ax2],'xy')
linkaxes([ax3,ax4],'xy')
axis([ax3 ax4],[0 60 75 100])