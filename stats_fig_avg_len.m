clear;clc;close all;
control_data = load('control_vocals_vs_days_syllable_len').control_vocals_vs_days;
treated_data = load('treated_vocals_vs_days_syllable_len').treated_vocals_vs_days;

control_syl_len = cell(length(5:11),1);
treated_syl_len = cell(length(5:11),1);


for i = 1:7
    control_syl_len{i,1} = cell2mat(control_data(:,i)).*1000;
    treated_syl_len{i,1} = cell2mat(treated_data(:,i)).*1000;
end

% plot grouped bar and error bar for control and treated syl len using cellfun
% Sample data generation (replace with your actual data)
% For demonstration, each cell will contain random numbers


% Calculating means and standard errors
means_control = cellfun(@mean, control_syl_len);
means_treated = cellfun(@mean, treated_syl_len);
std_err_control = cellfun(@(x) std(x)/sqrt(length(x)), control_syl_len);
std_err_treated = cellfun(@(x) std(x)/sqrt(length(x)), treated_syl_len);

% Preparing data for the bar chart
data = [means_control(:), means_treated(:)]; % Concatenating means
errors = [std_err_control(:), std_err_treated(:)]; % Concatenating standard errors

% Creating the bar chart
fig = figure;
bar(data, 'grouped');
hold on;

% Adding error bars - calculating positions for error bars
numGroups = size(data, 1);
numBars = size(data, 2);
groupWidth = min(0.8, numBars/(numBars + 1.5));
for i = 1:numBars
    x = (1:numGroups) - groupWidth/2 + (2*i-1) * groupWidth / (2*numBars); % Compute center positions
    errorbar(x, data(:,i), errors(:,i), 'k', 'linestyle', 'none');
end

% Customizing the graph
set(gca, 'XTickLabel', {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});
legend('Control', 'Treated');
ylabel('Mean len in ms');
xlabel('P Values');
title('Mean and Error of Control vs. Treated');

hold off;

% Define the days for readability in the output
days = {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'};

% Iterate through each of the 7 indices
for i = 1:length(control_syl_len)
    % Perform Independent Samples t-test
    [~, p_ttest] = ttest2(control_syl_len{i,1}, treated_syl_len{i,1});
    
    % Perform Mann-Whitney U Test (Wilcoxon rank-sum test)
    [p_ranksum, ~] = ranksum(control_syl_len{i,1}, treated_syl_len{i,1});
    
    % Print the results
    fprintf('%s: p-value (t-test) = %.4f, p-value (ranksum) = %.4f\n', days{i}, p_ttest, p_ranksum);
end
