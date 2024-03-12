clear;clc;close all;

all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};

control_3d_cell = load('control_3d_cell').control_3d_cell;
treated_3d_cell = load('treated_3d_cell').treated_3d_cell;

% 7 x a x 5
all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};

[control_mean, control_err] = make_vec5(control_3d_cell);
[treated_mean, treated_err] = make_vec5(treated_3d_cell);


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

xticks(1:5);
xticklabels(all_s)

xlabel('Group'); % Customize X-axis label as per your data
ylabel('Value'); % Customize Y-axis label as per your data
legend('Control', 'Treated', 'Location', 'Best'); % Add legend
title('Grouped Bar Chart with Error Bars'); % Add title


for s = 1:5
    c = control_3d_cell(:,:,s);
    t = treated_3d_cell(:,:,s);

    c1 = cat(1, c{:,:});
    t1 = cat(1, t{:,:});

    disp(['Syll type ' all_s{s}])
    [h,p] = ttest2(c1, t1);
    disp(['Ttest  h = ' num2str(h) ' p = ' num2str(p)])

    try
        [p,h] = ranksum(c1, t1);
    disp(['ranksum  h = ' num2str(h) ' p = ' num2str(p)])
    catch exception
        disp(['Ranksum error: ' exception.message]);
    end
    

end

function [db_5,err_5] = make_vec5(db)
    db_5 = zeros(5,1);
    err_5 = zeros(5,1);

    for s = 1:5
        cell_79 = db(:,:,s);

        cell_79_cat = cat(1, cell_79{:,:});

        db_5(s) = nanmean(cell_79_cat);
        err_5(s) = nanstd(cell_79_cat)/ sqrt(sum(~isnan(cell_79_cat)));
        
    end
    
end