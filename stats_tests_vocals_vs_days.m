% This script performs ANOVA and Chi-squared test to compare the number of syllables over days
clear;clc;

control_vocals_vs_days = load('control_vocals_vs_days').control_vocals_vs_days;
treated_vocals_vs_days = load('treated_vocals_vs_days').treated_vocals_vs_days;

control_vocals_vs_days_cell = cell(size(control_vocals_vs_days,2),1);
treated_vocals_vs_days_cell = cell(size(treated_vocals_vs_days,2),1);

for i = 1:size(control_vocals_vs_days,2)
    control_vocals_vs_days_cell{i} = control_vocals_vs_days(:,i);
end

for i = 1:size(treated_vocals_vs_days,2)
    treated_vocals_vs_days_cell{i} = treated_vocals_vs_days(:,i);
end

pdays = min(length(control_vocals_vs_days_cell),length(treated_vocals_vs_days_cell));
control_vocals_vs_days_cell = control_vocals_vs_days_cell(1:pdays);
treated_vocals_vs_days_cell = treated_vocals_vs_days_cell(1:pdays);

% Assuming you have control_vocals_vs_days_cell and treated_vocals_vs_days_cell as 7x1 cells
% Days are 5 to 11

disp('ANOVA ')
days = 5:11;
numDays = length(days);

% Create empty arrays to store p-values
p_values = zeros(numDays, 1);

% Loop through each day to perform ANOVA
for i = 1:numDays
    % Combine data for treated and control for the current day
    combined_data = [control_vocals_vs_days_cell{i}; treated_vocals_vs_days_cell{i}];
    
    % Create grouping variables
    num_control = length(control_vocals_vs_days_cell{i});
    num_treated = length(treated_vocals_vs_days_cell{i});
    groups = [ones(num_control, 1); 2*ones(num_treated, 1)];  % 1 for control, 2 for treated
    
    % Perform one-way ANOVA
    [p,~,~] = anovan(combined_data, {groups}, 'varnames', {'Treatment'}, 'display', 'off');
    
    % Store p-value (for the effect of Treatment)
    p_values(i) = p(1);
end

% Find days with significant difference (e.g., at alpha = 0.05)
significant_days = days(p_values < 0.05);

% Display
if isempty(significant_days)
    disp('No days show significant differences.')
else
    disp('Significant difference found on days:');
    disp(significant_days);
end


% -------------- CHI SQUARE -----------------------
disp('CHI SQUARE')
% Assuming you have control_vocals_vs_days_cell and treated_vocals_vs_days_cell as 7x1 cells
% Days are 5 to 11
days = 5:11;
numDays = length(days);

% Create empty arrays to store p-values
p_values = zeros(numDays, 1);

% Loop through each day to perform the Chi-squared test
for i = 1:numDays
    % Extract data for control and treated for the current day
    control_data = control_vocals_vs_days_cell{i};
    treated_data = treated_vocals_vs_days_cell{i};
    
    % Create the contingency table
    observed = [sum(control_data), sum(treated_data)];  % Sum if the data contains frequencies for each day
    
    % Perform Chi-squared test
    [~, p] = chi2gof(1:length(observed), 'freq', observed, 'expected', mean(observed) * ones(size(observed)), 'ctrs', 1:length(observed));
    
    % Store p-value
    p_values(i) = p;
end

% Find days with significant difference (e.g., at alpha = 0.05)
significant_days = days(p_values < 0.05);

% Display
if isempty(significant_days)
    disp('No days show significant differences.')
else
    disp('Significant difference found on days:');
    disp(significant_days);
end

