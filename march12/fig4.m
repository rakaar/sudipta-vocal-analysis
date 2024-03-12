clear;clc;close all;

all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};

control_3d_cell = load('control_3d_cell').control_3d_cell;
treated_3d_cell = load('treated_3d_cell').treated_3d_cell;

% 7 x a x 5
all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};
for sss = 1:5

disp([' Syllable type: ' all_s{sss}]);

[control_mean, control_err, control_cell] = make_ve7(control_3d_cell, sss);
[treated_mean, treated_err, treated_cell] = make_ve7(treated_3d_cell, sss);


% Assuming control_mean, treated_mean, control_err, and treated_err are defined as 5x1 vectors

% Combine mean values into a matrix where each row represents a group and each column represents a category
data = [control_mean, treated_mean].*1000;

% Combine error values into a similar structure
errors = [control_err, treated_err].*1000;

% Number of groups and number of bars in each group
numGroups = size(data, 1);
numBars = size(data, 2); 

% Plotting
figure;
b = bar(1:numGroups, data, 'grouped'); % Plot grouped bar

% Set colors for each bar
b(1).FaceColor = 'k'; % black for control
b(2).FaceColor = [0.5 0.5 0.5]; % gray for treated

hold on;

% Calculate the center positions of each bar
for i = 1:numBars
    x = b(i).XEndPoints; % get the endpoint positions of each bar
    % Plot error bars
    errorbar(x, data(:, i), errors(:, i), 'k', 'linestyle', 'none');
end

hold off;

xticks(1:7);
xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'})

xlabel('Group'); % Customize X-axis label as per your data
ylabel('Value'); % Customize Y-axis label as per your data
legend('Control', 'Treated', 'Location', 'Best'); % Add legend
title(all_s{sss}); % Add title
saveas(gcf, ['Mean_Duration_over_days_for_' all_s{sss} '.fig']);

for d = 1:7
    % ttest2
    [h,p] = ttest2(control_cell{d}, treated_cell{d});
    disp(['Ttest: h = ', num2str(h), ', p = ', num2str(p), ' for P', num2str(d+4), ' (control vs treated)' ])
    try
        [p,h] = ranksum(control_cell{d}, treated_cell{d});
        disp(['Ranksum: h = ', num2str(h), ', p = ', num2str(p), ' for P', num2str(d+4), ' (control vs treated)' ])
    catch
        disp('Ranksum: Error')
    end
end
end



function [m7, e7, cell7] = make_ve7(db,syllable_type_num)
    m7 = zeros(7,1);
    e7 = zeros(7,1);
    cell7 = cell(7,1);

    for d = 1:7
        c_for7 = db(d,:,syllable_type_num);
        c_for7_cat = cat(1, c_for7{:,:});

        cell7{d,1} = c_for7_cat;
        m7(d) = nanmean(c_for7_cat);
        e7(d) = nanstd(c_for7_cat)/ sqrt(sum(~isnan(c_for7_cat)));
    end
end