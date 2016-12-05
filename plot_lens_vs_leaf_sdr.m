%% Plot Leaf Node SDR vs Lens (for different Deriv Step Sizes)

lens_vec = [1 3 5 10 15 20 25 30 60 100 364]
% Plot Gasussian
plot(lens_vec, leaf_g_sdr_mat(1,:), ':+r', lens_vec, ...
    leaf_g_sdr_mat(2,:), '-.b*', lens_vec, leaf_g_sdr_mat(3,:), '--om', ...
    lens_vec, leaf_g_sdr_mat(4,:), 'gx')
legend('Deriv. Step: 1min', 'Deriv. Step 2min', 'Deriv. Step: 5min', ...
    'Deriv. Step: 10min')
xlabel('Data Lens Size (Days)')
ylabel('Leaf Node SDR (%)')

%% Plot JVHW
plot(lens_vec(1:5), leaf_jvhw_sdr_mat(1,1:5), ':+r', lens_vec(1:5), ...
    leaf_jvhw_sdr_mat(2,1:5), '--b*', lens_vec(1:5), leaf_jvhw_sdr_mat(3,1:5), '-.om', ...
    lens_vec(1:5), leaf_jvhw_sdr_mat(4,1:5), 'gx')
legend('Deriv. Step: 1min', 'Deriv. Step 2min', 'Deriv. Step: 5min', ...
    'Deriv. Step: 10min')
xlabel('Data Lens Size (Days)')
ylabel('Leaf Node SDR (%)')