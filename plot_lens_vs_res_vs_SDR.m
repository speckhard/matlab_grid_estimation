% Plot Lens vs Res vs SDR

lens_vec = [1 4 7 14 30 90];
res_vec = [1 5 15 30 60];

%% Gaussian plots
sdr_mat = results.mean_sdr_mat(:,:,1);
std_sdr_mat = results.std_sdr_mat(:,:,1);
leaf_sdr_mat = results.leaf_mean_sdr(:,:,1);
leaf_std_mat = results.leaf_std_sdr(:,:,1);
two_branch_sdr_mat = results.two_branch_mean_sdr(:,:,1);
two_branch_std_mat = results.two_branch_std_sdr(:,:,1);
three_branch_sdr_mat = results.three_branch_mean_sdr(:,:,1);
three_branch_std_mat = results.three_branch_std_sdr(:,:,1);

 
h = subplot(5,4,1)
errorbar(lens_vec, sdr_mat(1,:), std_sdr_mat(1,:))
title('1 minute resolution')
ylabel('SDR (%)')
xlabel('Lens size (days)')
subplot(5,4,2)
errorbar(lens_vec, leaf_sdr_mat(1,:),leaf_std_mat(1,:))

title({'SG2-solar Gaussian Deriv Analysis, Lens vs Res';...
    'Leaf SDR'})
%title('leaf SDR')

subplot(5,4,3)
errorbar(lens_vec, two_branch_sdr_mat(1,:),two_branch_std_mat(1,:))
title('Two-branch SDR')
subplot(5,4,4)
errorbar(lens_vec, three_branch_sdr_mat(1,:), three_branch_std_mat(1,:))
title('Three-branch SDR')

% Plot res = 5min
subplot(5,4,5)
errorbar(lens_vec, sdr_mat(2,:), std_sdr_mat(2,:))
title('5 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,6)
errorbar(lens_vec, leaf_sdr_mat(2,:),leaf_std_mat(2,:))
subplot(5,4,7)
errorbar(lens_vec, two_branch_sdr_mat(2,:),two_branch_std_mat(2,:))
subplot(5,4,8)
errorbar(lens_vec, three_branch_sdr_mat(2,:), three_branch_std_mat(2,:))

% Plot res = 15min
subplot(5,4,9)
errorbar(lens_vec, sdr_mat(3,:), std_sdr_mat(3,:))
title('15 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,10)
errorbar(lens_vec, leaf_sdr_mat(3,:),leaf_std_mat(3,:))
subplot(5,4,11)
errorbar(lens_vec, two_branch_sdr_mat(3,:),two_branch_std_mat(3,:))
subplot(5,4,12)
errorbar(lens_vec, three_branch_sdr_mat(3,:), three_branch_std_mat(3,:))

% Plot res = 30min
subplot(5,4,13)
errorbar(lens_vec, sdr_mat(4,:), std_sdr_mat(4,:))
title('30 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,14)
errorbar(lens_vec, leaf_sdr_mat(4,:),leaf_std_mat(4,:))
subplot(5,4,15)
errorbar(lens_vec, two_branch_sdr_mat(4,:),two_branch_std_mat(4,:))
subplot(5,4,16)
errorbar(lens_vec, three_branch_sdr_mat(4,:), three_branch_std_mat(4,:))

% Plot res = 60min
subplot(5,4,17)
errorbar(lens_vec, sdr_mat(5,:), std_sdr_mat(5,:))
title('60 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,18)
errorbar(lens_vec, leaf_sdr_mat(5,:),leaf_std_mat(5,:))
subplot(5,4,19)
errorbar(lens_vec, two_branch_sdr_mat(5,:),two_branch_std_mat(5,:))
subplot(5,4,20)
errorbar(lens_vec, three_branch_sdr_mat(5,:), three_branch_std_mat(5,:))

%% JVHW plots
% The JVHW peroforms worse for small lenses, we remove lens 1 and 4
lens_vec = [7 14 30 90];
sdr_mat = results.mean_sdr_mat(:,3:end,2);
std_sdr_mat = results.std_sdr_mat(:,3:end,2);
leaf_sdr_mat = results.leaf_mean_sdr(:,3:end,2);
leaf_std_mat = results.leaf_std_sdr(:,3:end,2);
two_branch_sdr_mat = results.two_branch_mean_sdr(:,3:end,2);
two_branch_std_mat = results.two_branch_std_sdr(:,3:end,2);
three_branch_sdr_mat = results.three_branch_mean_sdr(:,3:end,2);
three_branch_std_mat = results.three_branch_std_sdr(:,3:end,2);

 
h = subplot(5,4,1)
errorbar(lens_vec, sdr_mat(1,:), std_sdr_mat(1,:))
title('1 minute resolution')
ylabel('SDR (%)')
xlabel('Lens size (days)')
subplot(5,4,2)
errorbar(lens_vec, leaf_sdr_mat(1,:),leaf_std_mat(1,:))

title({'SG2-solar JVHW Deriv Analysis, Lens vs Res';...
    'Leaf SDR'})
%title('leaf SDR')

subplot(5,4,3)
errorbar(lens_vec, two_branch_sdr_mat(1,:),two_branch_std_mat(1,:))
title('Two-branch SDR')
subplot(5,4,4)
errorbar(lens_vec, three_branch_sdr_mat(1,:), three_branch_std_mat(1,:))
title('Three-branch SDR')

% Plot res = 5min
subplot(5,4,5)
errorbar(lens_vec, sdr_mat(2,:), std_sdr_mat(2,:))
title('5 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,6)
errorbar(lens_vec, leaf_sdr_mat(2,:),leaf_std_mat(2,:))
subplot(5,4,7)
errorbar(lens_vec, two_branch_sdr_mat(2,:),two_branch_std_mat(2,:))
subplot(5,4,8)
errorbar(lens_vec, three_branch_sdr_mat(2,:), three_branch_std_mat(2,:))

% Plot res = 15min
subplot(5,4,9)
errorbar(lens_vec, sdr_mat(3,:), std_sdr_mat(3,:))
title('15 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,10)
errorbar(lens_vec, leaf_sdr_mat(3,:),leaf_std_mat(3,:))
subplot(5,4,11)
errorbar(lens_vec, two_branch_sdr_mat(3,:),two_branch_std_mat(3,:))
subplot(5,4,12)
errorbar(lens_vec, three_branch_sdr_mat(3,:), three_branch_std_mat(3,:))

% Plot res = 30min
subplot(5,4,13)
errorbar(lens_vec, sdr_mat(4,:), std_sdr_mat(4,:))
title('30 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,14)
errorbar(lens_vec, leaf_sdr_mat(4,:),leaf_std_mat(4,:))
subplot(5,4,15)
errorbar(lens_vec, two_branch_sdr_mat(4,:),two_branch_std_mat(4,:))
subplot(5,4,16)
errorbar(lens_vec, three_branch_sdr_mat(4,:), three_branch_std_mat(4,:))

% Plot res = 60min
subplot(5,4,17)
errorbar(lens_vec, sdr_mat(5,:), std_sdr_mat(5,:))
title('60 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,18)
errorbar(lens_vec, leaf_sdr_mat(5,:),leaf_std_mat(5,:))
subplot(5,4,19)
errorbar(lens_vec, two_branch_sdr_mat(5,:),two_branch_std_mat(5,:))
subplot(5,4,20)
errorbar(lens_vec, three_branch_sdr_mat(5,:), three_branch_std_mat(5,:))

%% Discrete plots
% The Discrete peroforms worse for small lenses, we remove lens 1 and 4
lens_vec = [7 14 30 90];
sdr_mat = results.mean_sdr_mat(:,3:end,3);
std_sdr_mat = results.std_sdr_mat(:,3:end,3);
leaf_sdr_mat = results.leaf_mean_sdr(:,3:end,3);
leaf_std_mat = results.leaf_std_sdr(:,3:end,3);
two_branch_sdr_mat = results.two_branch_mean_sdr(:,3:end,3);
two_branch_std_mat = results.two_branch_std_sdr(:,3:end,3);
three_branch_sdr_mat = results.three_branch_mean_sdr(:,3:end,3);
three_branch_std_mat = results.three_branch_std_sdr(:,3:end,3);

 
h = subplot(5,4,1)
errorbar(lens_vec, sdr_mat(1,:), std_sdr_mat(1,:))
title('1 minute resolution')
ylabel('SDR (%)')
xlabel('Lens size (days)')
subplot(5,4,2)
errorbar(lens_vec, leaf_sdr_mat(1,:),leaf_std_mat(1,:))

title({'SG2-solar Discrete Deriv Analysis, Lens vs Res';...
    'Leaf SDR'})
%title('leaf SDR')

subplot(5,4,3)
errorbar(lens_vec, two_branch_sdr_mat(1,:),two_branch_std_mat(1,:))
title('Two-branch SDR')
subplot(5,4,4)
errorbar(lens_vec, three_branch_sdr_mat(1,:), three_branch_std_mat(1,:))
title('Three-branch SDR')

% Plot res = 5min
subplot(5,4,5)
errorbar(lens_vec, sdr_mat(2,:), std_sdr_mat(2,:))
title('5 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,6)
errorbar(lens_vec, leaf_sdr_mat(2,:),leaf_std_mat(2,:))
subplot(5,4,7)
errorbar(lens_vec, two_branch_sdr_mat(2,:),two_branch_std_mat(2,:))
subplot(5,4,8)
errorbar(lens_vec, three_branch_sdr_mat(2,:), three_branch_std_mat(2,:))

% Plot res = 15min
subplot(5,4,9)
errorbar(lens_vec, sdr_mat(3,:), std_sdr_mat(3,:))
title('15 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,10)
errorbar(lens_vec, leaf_sdr_mat(3,:),leaf_std_mat(3,:))
subplot(5,4,11)
errorbar(lens_vec, two_branch_sdr_mat(3,:),two_branch_std_mat(3,:))
subplot(5,4,12)
errorbar(lens_vec, three_branch_sdr_mat(3,:), three_branch_std_mat(3,:))

% Plot res = 30min
subplot(5,4,13)
errorbar(lens_vec, sdr_mat(4,:), std_sdr_mat(4,:))
title('30 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,14)
errorbar(lens_vec, leaf_sdr_mat(4,:),leaf_std_mat(4,:))
subplot(5,4,15)
errorbar(lens_vec, two_branch_sdr_mat(4,:),two_branch_std_mat(4,:))
subplot(5,4,16)
errorbar(lens_vec, three_branch_sdr_mat(4,:), three_branch_std_mat(4,:))

% Plot res = 60min
subplot(5,4,17)
errorbar(lens_vec, sdr_mat(5,:), std_sdr_mat(5,:))
title('60 minute resolution')
xlabel('Lens size (days)')
ylabel('SDR (%)')
subplot(5,4,18)
errorbar(lens_vec, leaf_sdr_mat(5,:),leaf_std_mat(5,:))
subplot(5,4,19)
errorbar(lens_vec, two_branch_sdr_mat(5,:),two_branch_std_mat(5,:))
subplot(5,4,20)
errorbar(lens_vec, three_branch_sdr_mat(5,:), three_branch_std_mat(5,:))


%% Plot Only one plot of SDR vs Resolution
lens_vec = [364];
res_vec = [1 5 15 30 60];
sdr_mat = results.mean_sdr_mat(:,end,3);
std_sdr_mat = results.std_sdr_mat(:,end,3);
leaf_sdr_mat = results.leaf_mean_sdr(:,end,3);
leaf_std_mat = results.leaf_std_sdr(:,end,3);
two_branch_sdr_mat = results.two_branch_mean_sdr(:,end,3);
two_branch_std_mat = results.two_branch_std_sdr(:,end,3);
three_branch_sdr_mat = results.three_branch_mean_sdr(:,end,3);
three_branch_std_mat = results.three_branch_std_sdr(:,end,3);

figure(1)
plot(res_vec,sdr_mat, '--s', res_vec, leaf_sdr_mat, '-.o', ...
    res_vec, two_branch_sdr_mat, ':d', res_vec, three_branch_sdr_mat,...
    'x','LineWidth', 1.5) 
legend('SDR', 'leaf node SDR', 'two branch SDR', 'three branch SDR')
xlabel('Downsampling resolution (mins)')
ylabel('SDR (%)')

