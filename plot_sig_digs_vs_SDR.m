%% Plot the Resolution vs SDR for SG and SG solar datasets
multiplier_vec = [1E1 0.5E2 1E2 0.5E3 1E3 ];
logmultiplier = log10(multiplier_vec);

%% Plot SG data
plot(logmultiplier, sigdigsSGmat(1,:), '-.r+', ...
    logmultiplier, sigdigsSGmat(2,:), ':bo',...
    logmultiplier, sigdigsSGmat(3,:), '--c*')
xlabel('Base Ten Multiplier Before Rounding (log10(10^x))')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')


%% Plot SG-solar data

plot(logmultiplier, sigdigsSGsolarmat(1,:), '-.r+', ...
    logmultiplier, sigdigsSGsolarmat(2,:), ':bo',...
    logmultiplier, sigdigsSGsolarmat(3,:), '--c*')
xlabel('Base Ten Multiplier Before Rounding (log10(10^x))')
ylabel('SDR (%)')
legend('Gaussian','JVHW - 14b','Discrete - 14b')

