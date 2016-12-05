%% Plot Noise vs. SDR for all different MI methods
% Gaussian
noise_percent_vec = [1E-5 1E-4 1E-3 1E-2];
log_noise_percent_vec = log10(noise_percent_vec)

mean_sdr_gaussian_vec = mean(noise_vec_gaussian(:,4:end));
std_sdr_gaussian_vec = std(noise_vec_gaussian(:,4:end))

errorbar(log_noise_percent_vec,mean_sdr_gaussian_vec, ...
    std_sdr_gaussian_vec, '-.r*','LineWidth', 1.5)
xlabel('Logarithm of Percent of Mean Voltage of Node Added as Noise (log(%))')
ylabel('SDR (%)')

%% JVHW - 14b

mean_sdr_JVHW_vec = mean(noise_vec_JVHW(:,4:end));
std_sdr_JVHW_vec = std(noise_vec_JVHW(:,4:end))

errorbar(log_noise_percent_vec,mean_sdr_JVHW_vec, ...
    std_sdr_JVHW_vec, '-.r*','LineWidth', 1.5)
xlabel('Logarithm of Percent of Mean Voltage of Node Added as Noise (log(%))')
ylabel('SDR (%)')

%% Discrete - 14b
mean_sdr_JVHW_vec = mean(noise_vec_JVHW(:,4:end));
std_sdr_JVHW_vec = std(noise_vec_JVHW(:,4:end))

errorbar(log_noise_percent_vec,mean_sdr_JVHW_vec, ...
    std_sdr_JVHW_vec, '-.r*','LineWidth', 1.5)
xlabel('Logarithm of Percent of Mean Voltage of Node Added as Noise (log(%))')
ylabel('SDR (%)')
