% Bar plot
figure;
barHandles = bar([control_mean', treated_mean'], 'BarWidth', 1);

% Set bar colors
barHandles(1).FaceColor = [0.5 0.5 0.5]; % Set first bar color to grey
barHandles(2).FaceColor = 'k'; % Set second bar color to black

% title('Control vs Treated');

% Getting bar x-positions for error bars and individual data points
xControl = barHandles(1).XEndPoints;
xTreated = barHandles(2).XEndPoints;

% Calculate the width of each bar for positioning the data points
barWidth = mean(diff(xControl)) / 3; % Adjust the divisor as needed to fit your data

% Add error bars
hold on;
errorbar(xControl, control_mean, control_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
errorbar(xTreated, treated_mean, treated_err, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);


% Plot individual data points for control and treated data
markerSize = 8; % Adjust the marker size as needed
for i = 1:num_days
    % Control data points, use black round markers ('o')
    plot(xControl(i) * ones(size(control_data, 1), 1), control_data(:, i), 'ko', 'MarkerSize', markerSize, 'MarkerFaceColor', 'k');
    
    % Treated data points, use black square markers ('s')
    plot(xTreated(i) * ones(size(treated_data, 1), 1), treated_data(:, i), 'ks', 'MarkerSize', markerSize, 'MarkerFaceColor', 'k');
end



hold off;

% Setting x-axis labels to P5, P6,..., P11
xticks(1:7);
xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});

% Adding legend
legend(barHandles, {'Control', 'Treated'}, 'TextColor', 'k', 'EdgeColor', 'k');
xlabel('Age (days)', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Total number of Syllables', 'FontSize', 18, 'FontWeight', 'bold')

% After creating your plot, add the following:

% Remove the top and right axis lines
ax = gca; % Get current axes
ax.Box = 'off'; % Turn off the box surrounding the plot

% Keep only the bottom (x-axis) and left (y-axis) lines visible
ax.XAxis.LineWidth = 3; % Adjust the line width as you like
ax.YAxis.LineWidth = 3; % Adjust the line width as you like

set(ax.YAxis, 'TickDir', 'out'); % Set Y-axis ticks to point outwards
