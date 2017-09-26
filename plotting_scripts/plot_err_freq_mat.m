% Script to plot nodes vs. lens size vs. err freq

% Let's make a heat map of error

x = squeeze(1:220);
y = results.lens_vec
y = [30, 60, 90, 120, 180, 364]; %/(60*24); % Lens in days.

err_freq_mat = squeeze(results.err_freq_mat);

imagesc(y,x,err_freq_mat(:,:,1));

xlabel('Length of Data (Days)')
ylabel('Bus Label')
xticks([linspace(30,364,6)])
xticklabels({'30','60','90','120','180','364'})
%set(gca,'XTickLabel',{'30','60','90','180','364'})
%title('Error Frequency for SG2-solar, Gaussian')
%%
colorbar
map = [1.0, 1.0, 1.0
    1.0, 0.9, 0.6
    1, 0.9, 0
    1, 0.7, 0
    1, 0.5, 0
    1, 0, 0];
colormap(map)
set(gca,'FontSize',17);