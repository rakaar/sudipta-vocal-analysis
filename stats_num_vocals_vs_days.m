clear;clc;

control_data = load('control_vocals_vs_days').control_vocals_vs_days;
treated_data = load('treated_vocals_vs_days').treated_vocals_vs_days;
control_data(1,1) = nan;
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
control_mean = nanmean(control_data,1);
control_std = nanstd(control_data,1);
control_err = zeros(7,1);
for i = 1:7
    control_err(i) = control_std(i)./sqrt(sum(~isnan(control_data(:,i))));
end


% treated
treated_mean = mean(treated_data,1);
treated_std = std(treated_data,1);
treated_err = treated_std./sqrt(size(treated_data,1));

% Bar plot
figure;
barHandles = bar([control_mean', treated_mean']);

% Set bar colors
barHandles(1).FaceColor = [0.5 0.5 0.5]; % Set first bar color to grey
barHandles(2).FaceColor = 'k'; % Set second bar color to black

title('Control vs Treated');

% Getting bar x-positions for error bars
xControl = barHandles(1).XEndPoints;
xTreated = barHandles(2).XEndPoints;

% Add error bars
hold on;
errorbar(xControl, control_mean, control_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
errorbar(xTreated, treated_mean, treated_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
hold off;

% Setting x-axis labels to P5, P6,..., P11
xticks(1:7);
xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});

% Adding legend
legend(barHandles, {'Control', 'Treated'}, 'TextColor', 'k', 'EdgeColor', 'k');
xlabel('Age (days)', 'FontSize', 18)
ylabel('Total number of Syllabels', 'FontSize', 18)
% Assuming control_mean, treated_mean, control_err, treated_err are defined
% Number of data points
% nDataPoints = length(control_mean);

% % Generate x values for each group to plot
% xControl = 1:nDataPoints; % e.g., [1 2 3 4 5 6 7]
% xTreated = xControl + 0.1; % Slight offset to separate the error bars visually

% % Create the plot
% figure;
% hold on;

% % Plot lines connecting control and treated points
% plot(xControl, control_mean, '-ko', 'MarkerFaceColor', 'w', 'LineWidth', 1.5, 'MarkerSize', 8);
% plot(xTreated, treated_mean, '-ko', 'MarkerFaceColor', 'k', 'LineWidth', 1.5, 'MarkerSize', 8);

% % Plot error bars for control and treated data
% errorbar(xControl, control_mean, control_err, 'k', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
% errorbar(xTreated, treated_mean, treated_err, 'k', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);

% % Customize the plot
% title('Control vs Treated');
% xticks(1:nDataPoints);
% xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});
% legend('Control','Treated');
% xlabel('Age (days)');
% ylabel('Number of Syllabels')
% hold off;
