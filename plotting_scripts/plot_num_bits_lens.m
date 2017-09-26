% Plot Variable Deriv Step vs SDR

%% Plot Regular SDR - SGlens
num_bits = [4 6 8 10 12 14 16];
sdr_mat_g = SG1results.mean_sdr_mat(1,:); %SG1results.mean_sdr_mat(1,:); 
std_mat_g = SG1results.std_sdr_mat(1,:); %SG1results.std_sdr_mat(1,:); 

ax1 = subplot(3,2,1)
errorbar(num_bits, sdr_mat_g, std_mat_g,'--o',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
%xlabel('Number of Bits of Voltage Data')
ylabel('SDR (%)')
legend({'Gaussian'}, 'Location', 'southeast')
title('SG1')
set(gca,'FontSize',12);
%% Plot Regular SDR - SGsolarlens
num_bits = [4 6 8 10 12 14 16];
sdr_mat_g = SG1solarresults.mean_sdr_mat(1,:); 
std_mat_g = SG1solarresults.std_sdr_mat(1,:); 

ax2 = subplot(3,2,2)
errorbar(num_bits, sdr_mat_g, std_mat_g,'--o',...
    'LineWidth', 1.5,'markers',15) 
set(gca,'FontSize',18);
%xlabel('Number of Bits of Voltage Data')
%ylabel('SDR (%)')
legend({'Gaussian'}, 'Location', 'southeast')
title('SG2-solar')
set(gca,'FontSize',12);

%% Plot Regular SDR - SG1 JVHW
num_bits = [4 6 8 10 12 14 16];
sdr_mat_j = SG1results.mean_sdr_mat(2,:); 
std_mat_j = SG1results.std_sdr_mat(2,:); 

ax3 = subplot(3,2,3)
errorbar(num_bits, sdr_mat_j, std_mat_j,'--o',...
    'LineWidth', 1.5,'markers',15,'Color', [0.8500,0.3250,0]) 
set(gca,'FontSize',18);
%xlabel('Number of Bits of Voltage Data')
ylabel('SDR (%)')
legend({'JVHW'}, 'Location', 'southeast')
%title('JVHW')
set(gca,'FontSize',12);

%% Plot Regular SDR - SG1solar Gaussian
num_bits = [4 6 8 10 12 14 16];
sdr_mat_j = SG1solarresults.mean_sdr_mat(1,:); 
std_mat_j = SG1solarresults.std_sdr_mat(1,:); 

ax4 = subplot(3,2,4)
errorbar(num_bits, sdr_mat_j, std_mat_j,'--o',...
    'LineWidth', 1.5,'markers',15, 'Color', [0.8500,0.3250,0]) 
set(gca,'FontSize',18);
%xlabel('Number of Bits of Voltage Data')
%ylabel('SDR (%)')
%legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
%title('JVHW')
set(gca,'FontSize',12);
legend({'JVHW'}, 'Location', 'southeast')

%% Plot Regular SDR - SG1solar Discrete
num_bits = [4 6 8 10 12 14 16];
sdr_mat_d = SG1results.mean_sdr_mat(3,:); 
std_mat_d = SG1results.std_sdr_mat(3,:); 

ax5 = subplot(3,2,5)
errorbar(num_bits, sdr_mat_d, std_mat_d,'--o',...
    'LineWidth', 1.5,'markers',15,'Color', [0.9290, 0.6940,0.1250]) 
set(gca,'FontSize',18);
xlabel('Number of Bits of Voltage Data')
ylabel('SDR (%)')
%legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
%title('Discrete')
set(gca,'FontSize',12);
legend({'Discrete'}, 'Location', 'southeast')

%% Plot Regular SDR - SG1solar Discrete
num_bits = [4 6 8 10 12 14 16];
sdr_mat_d = SG1solarresults.mean_sdr_mat(3,:); 
std_mat_d = SG1solarresults.std_sdr_mat(3,:); 

ax6 = subplot(3,2,6)
errorbar(num_bits, sdr_mat_d, std_mat_d,'--o',...
    'LineWidth', 1.5,'markers',15,'Color', [0.9290, 0.6940,0.1250]) 
set(gca,'FontSize',18);
xlabel('Number of Bits of Voltage Data')
%ylabel('SDR (%)')
%legend({'Gaussian','JVHW','Discrete'}, 'Location', 'southeast')
%title('Discrete')
set(gca,'FontSize',12);
legend({'Discrete'}, 'Location', 'southeast')

%% Link Axes
linkaxes([ax1,ax2],'xy')
linkaxes([ax4,ax3],'xy')
linkaxes([ax5,ax6],'xy')
axis([ax2, ax4, ax6],[4 16 75 100])
% axis(ax1,[4 16 75 105])
% axis(ax5,[4 16 75 105])