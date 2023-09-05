clear;clc;
control_syllables_vs_days = load('control_syllables_vs_days.mat').control_syllables_vs_days;
treated_syllables_vs_days = load('treated_syllables_vs_days.mat').treated_syllables_vs_days;

postnatal_days = 5:11;
syllable_type_strs = {'single', 'noise', 'jump', 'harmonic', 'other'};
% Loop through each day and each syllable type
for day = 1:7
    for syllable_type = 1:5
        control_data = control_syllables_vs_days{syllable_type, day};
        treated_data = treated_syllables_vs_days{syllable_type, day};
        
        % ANOVA (Let's consider one-way for this example)
        all_data = [control_data; treated_data];
        groups = [ones(length(control_data), 1); 2 * ones(length(treated_data), 1)];
        
        % For one-way ANOVA
        [p, ~, ~] = anova1(all_data, groups, 'off'); % 'off' to not display the figure
        
        if p < 0.05
            disp(['Day ' num2str(postnatal_days(day)) ' ANOVA diff in syllable - ' syllable_type_strs{syllable_type} ])
        end
        
        % % Chi-square (assuming your data are frequencies/counts)
        % contingency_table = [sum(control_data), sum(treated_data)]; % Build your table accordingly
        % [h, p_chi2] = chi2gof(contingency_table); % Apply chi-square goodness-of-fit test
        
        % if h == 1
        %     fprintf('Day %d, Syllable %d: Chi-square shows significant difference (p = %f)\n', day, syllable_type, p_chi2);
        % end
    end
    disp('-------------------------------')
end
