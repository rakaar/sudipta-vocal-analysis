clear;clc;close all;

control_rate_cell = load('control_rate_vs_days.mat').control_vocals_vs_days;
treated_rate_cell = load('treated_rate_vs_days.mat').treated_vocals_vs_days;

days = 5:11;
control_rate_days_wise_cell = cell(length(days),1);
treated_rate_days_wise_cell = cell(length(days),1);

for i = 1:length(days)
    control_rate_days_wise_cell{i,1} = (control_rate_cell(:,i));
    treated_rate_days_wise_cell{i,1} = (treated_rate_cell(:,i));
    
end

% using cellfun find mean and error bar of the above 2
control_rate_mean = cellfun(@mean,control_rate_days_wise_cell);
% std err = std/ sqrt len
control_rate_std = cellfun(@std,control_rate_days_wise_cell)./sqrt(cellfun(@length,control_rate_days_wise_cell));

treated_rate_mean = cellfun(@mean,treated_rate_days_wise_cell);
treated_rate_std = cellfun(@std,treated_rate_days_wise_cell)./sqrt(cellfun(@length,treated_rate_days_wise_cell));

% Assuming control_rate_mean, treated_rate_mean, control_rate_std, and treated_rate_std are defined

% Sample data setup (you should replace these with your actual data vectors)
days = {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'}; % Days labels

% Assuming control_rate_mean, treated_rate_mean, control_rate_std, treated_rate_std are calculated as mentioned

% Plotting
figure;

% Grouped bar chart
barData = [control_rate_mean, treated_rate_mean]; % Concatenate mean values for grouped display
hb = bar(barData, 'grouped');
hb(1).FaceColor = 'k'; % black for control
hb(2).FaceColor = [0.5 0.5 0.5]; % gray for treated

hold on;

% Error bar calculation and plotting
numGroups = size(barData, 1); % Number of days
numBars = size(barData, 2); % Number of conditions (control, treated)
groupWidth = min(0.8, numBars/(numBars + 1.5)); % Calculate the group width

% Loop through each group (day) to plot error bars
for i = 1:numBars
    % Calculate x position for the error bars
    x = hb(i).XEndPoints; % XEndPoints gives the center of each bar
    if i == 1 % Control
        errorbar(x, control_rate_mean, control_rate_std, 'k', 'linestyle', 'none');
    else % Treated
        errorbar(x, treated_rate_mean, treated_rate_std, 'k', 'linestyle', 'none');
    end
end

hold off;

% Customize the plot
set(gca, 'XTick', 1:numGroups, 'XTickLabel', days); % Set custom x-axis tick labels to days
xlabel('Days');
ylabel('Rate');
legend('Control', 'Treated');
title('Grouped Bar Chart with Error Bars for Control and Treated Groups Across Days');
set(gcf, 'color', 'w'); % Set background color to white

%% stats

% control_rate_days_wise_cell{i,1} 
% treated_rate_days_wise_cell{i,1} 

for i = 1:7
    [h,p] = ttest2(control_rate_days_wise_cell{i,1},treated_rate_days_wise_cell{i,1});
    disp(['TTEST-Day ',num2str(i+4),' p-value: ',num2str(p) ' h = ' num2str(h)])

    [p,h] = ranksum(control_rate_days_wise_cell{i,1},treated_rate_days_wise_cell{i,1});
    disp(['RANKSUM-Day ',num2str(i+4),' p-value: ',num2str(p) ' h = ' num2str(h)])
end



