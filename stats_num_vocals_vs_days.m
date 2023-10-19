clear;clc;

control_data = load('control_vocals_vs_days').control_vocals_vs_days;
treated_data = load('treated_vocals_vs_days').treated_vocals_vs_days;

% change to same number of days
control_data = control_data(:, 1:7); % P5 - P11
treated_data = treated_data(:, 1:7); % P5 - P11

num_days = size(control_data, 2);

for d = 1:num_days
    disp(['------ Day ' num2str(d+4) ' ------' ])
    [~,p] = ttest2(control_data(:, d), treated_data(:, d));
    disp(['T-test: Day ' num2str(d+4) ' p-value: ' num2str(p)]);

    [p,~] = ranksum(control_data(:, d), treated_data(:, d));
    disp(['Ranksum: Day ' num2str(d+4) ' p-value: ' num2str(p)]);
end


% CONTROL
control_mean = mean(control_data,1);
control_std = std(control_data,1);
control_err = control_std./sqrt(size(control_data,1));

% treated
treated_mean = mean(treated_data,1);
treated_std = std(treated_data,1);
treated_err = treated_std./sqrt(size(treated_data,1));

% Bar plot
figure;
barHandles = bar([control_mean', treated_mean']);
legend('Control','Treated');
title('Control vs Treated');

% Getting bar x-positions
xControl = barHandles(1).XEndPoints;
xTreated = barHandles(2).XEndPoints;

% Add error bars
hold on;
errorbar(xControl, control_mean, control_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
errorbar(xTreated, treated_mean, treated_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);

% Setting x-axis labels to P5, P6,..., P11
xticks(1:7);
xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});

hold off;
