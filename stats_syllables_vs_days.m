clear;clc;
control_syllables_vs_days = load('control_syllables_vs_days.mat').control_syllables_vs_days;
treated_syllables_vs_days = load('treated_syllables_vs_days.mat').treated_syllables_vs_days;

% Generate synthetic data for illustration
% Assume that control_syllables_vs_days and treated_syllables_vs_days are already available

% Initialize results
anova_p_values = zeros(1, 7);
chi2_p_values = zeros(1, 7);
syllable_diff_anova = cell(1, 7);

% Loop through each day and perform ANOVA and Chi-Square tests
for day = 1:7
    control_data = control_syllables_vs_days(:, day);
    treated_data = treated_syllables_vs_days(:, day);

    % Combine data for ANOVA
    combined_data = [control_data; treated_data];
    groups = [ones(size(control_data)); 2 * ones(size(treated_data))];

    % Perform ANOVA
    [~, anova_table] = anova1(combined_data, groups, 'off');  % 'off' suppresses the ANOVA plot
    anova_p_values(day) = anova_table{2, 6};

    % Perform Chi-Square test
    observed = [control_data, treated_data];
    [~, chi2_p_values(day)] = crosstab(observed(:, 1), observed(:, 2));

    % Check which syllable is mainly different on each day (Post-hoc analysis)
    if anova_p_values(day) < 0.05
        [~,~,stats] = anova1(combined_data, groups, 'off');
        c = multcompare(stats, 'Alpha', 0.05, 'Display', 'off');
        syllable_diff_anova{day} = c(:, [1 2 6]);
    end
end

% Identify days with significant differences
days_diff_anova = find(anova_p_values < 0.05);
days_diff_chi2 = find(chi2_p_values < 0.05);

% Display the days with significant differences
disp('Days with significant differences according to ANOVA:');
disp(days_diff_anova);

disp('Days with significant differences according to Chi-Square:');
disp(days_diff_chi2);

% Display which syllable is mainly different for each day
disp('Syllables that are mainly different for each day according to post-hoc tests:');
disp(syllable_diff_anova);
