% Assuming control_sum5 and treated_sum5 are 5x1 cells with numeric arrays inside
control_means = cellfun(@mean, control_sum5);
treated_means = cellfun(@mean, treated_sum5);

% Calculate standard errors
control_sems = cellfun(@(x) std(x)/sqrt(length(x)), control_sum5);
treated_sems = cellfun(@(x) std(x)/sqrt(length(x)), treated_sum5);

% Assuming control_means, treated_means, control_sems, and treated_sems are already calculated

% Number of groups
numGroups = length(control_means);

% Create a figure
figure;

% Positions for the groups
groupWidth = min(0.8, numGroups/(numGroups + 1.5));
pos = 1:numGroups;

% Plotting the bars with specified colors
b = bar([control_means, treated_means], 'grouped');
b(1).FaceColor = 'black'; % Control bar color
b(2).FaceColor = [0.5 0.5 0.5]; % Treated bar color

% Calculating positions for the error bars
% Error bars are now centered on the bars by finding the center positions
controlErrorBarPositions = b(1).XEndPoints;
treatedErrorBarPositions = b(2).XEndPoints;

hold on; % Keep the bar chart visible while adding error bars and scatter points

% Adding error bars centered on each bar
errorbar(controlErrorBarPositions, control_means, control_sems, 'k', 'linestyle', 'none');
errorbar(treatedErrorBarPositions, treated_means, treated_sems, 'k', 'linestyle', 'none');

% Adding individual data points as scatter plots, centered on each bar
for i = 1:numGroups
    % Control
    scatter(repmat(controlErrorBarPositions(i), size(control_sum5{i})), control_sum5{i}, 'blue', 'filled');
    % Treated
    scatter(repmat(treatedErrorBarPositions(i), size(treated_sum5{i})), treated_sum5{i}, 'red', 'filled');
end

hold off;

% Enhancing the plot
set(gca, 'XTick', 1:numGroups); % Set X-ticks to match the number of groups
set(gca, 'XTickLabel', {'single', 'noise', 'jump', 'harmonic', 'other'}); % Naming syllable types
legend({'Control', 'Treated'}, 'Location', 'Best'); % Add a legend
ylabel('Mean ± SEM'); % Y-axis label
xlabel('Syllable Type'); % X-axis label changed from 'Group'
title('Grouped Bar Plot with Error Bars and Individual Data Points'); % Title

s_types =  {'single', 'noise', 'jump', 'harmonic', 'other'};
for i = 1:5
    [h,p] = ttest2(control_sum5{i}, treated_sum5{i});
    disp(['T-test:p-value for ' s_types{i} ' syllable type: ' num2str(p)]);
    % ranksum
    [p, h] = ranksum(control_sum5{i}, treated_sum5{i});
    disp(['ranksum:p-value for ' s_types{i} ' syllable type: ' num2str(p)]);
end