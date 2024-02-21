% Load the data for averages and standard errors
control_avg_fraction = load('control_avg_fraction').avg_fraction;
treated_avg_fraction = load('treated_avg_fraction').avg_fraction;
control_std_error = load('control_std_error').std_error;
treated_std_error = load('treated_std_error').std_error;

% Extract field names for x-axis labels from the structure

x_labels = fieldnames(new_all_animals_struct);

% Number of data points (assuming each field corresponds to a data point)
num_points = length(x_labels);

% Bar plot
figure;
barHandles = bar([control_avg_fraction, treated_avg_fraction], 'BarWidth', 1);

% Set bar colors
barHandles(1).FaceColor = [0.5 0.5 0.5]; % Set first bar color to grey
barHandles(2).FaceColor = 'k'; % Set second bar color to black

% Getting bar x-positions for error bars
xControl = barHandles(1).XEndPoints;
xTreated = barHandles(2).XEndPoints;

% Add error bars
hold on;
errorbar(xControl, control_avg_fraction, control_std_error, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
errorbar(xTreated, treated_avg_fraction, treated_std_error, 'k.', 'linestyle', 'none', 'linewidth', 1.5, 'capsize', 10);
hold off;

% Setting x-axis labels to the fieldnames of the structure
xticks(1:num_points);
xticklabels(x_labels);
xtickangle(45); % Rotate xtick labels for better visibility
set(gca, 'FontSize', 16); % Set font size of xtick labels

% Adding legend and labels with bold font
legend(barHandles, {'Control', 'Treated'}, 'TextColor', 'k', 'EdgeColor', 'k');
xlabel('Vocalization Type', 'FontSize', 18, 'FontWeight', 'bold')
ylabel('Total number of Syllables', 'FontSize', 18, 'FontWeight', 'bold')

% Customize the axes
ax = gca; % Get current axes
ax.Box = 'off'; % Turn off the box surrounding the plot

% Keep only the bottom (x-axis) and left (y-axis) lines visible
ax.XAxis.LineWidth = 3; % Adjust the line width as you like
ax.YAxis.LineWidth = 3; % Adjust the line width as you like

set(ax.YAxis, 'TickDir', 'out'); % Set Y-axis ticks to point outwards
