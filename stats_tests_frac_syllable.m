clear;clc;


%%%%%%%%%%% Fraction of syllables %%%%%%%%%%%%%%%
control_frac_syllables = load('control_frac_syllables').control_frac_syllables;
treated_frac_syllables = load('treated_frac_syllables').treated_frac_syllables;

% ----------- Control --------------
syllable_to_process = control_frac_syllables;
fields = fieldnames(syllable_to_process);

% In each row, calculate the fraction of each syllable
for i = 1:length(syllable_to_process)
    total_syllables = sum(cell2mat(struct2cell(syllable_to_process(i))));
    for j = 1:length(fields)
        syllable_to_process(i).(fields{j}) = syllable_to_process(i).(fields{j}) / total_syllables;
    end
end


all_fractions = cell(length(fields),1);
for i = 1:length(syllable_to_process)
    for j = 1:length(fields)
        all_fractions{j,1} = [all_fractions{j,1} syllable_to_process(i).(fields{j})];
    end
end

all_control_fractions = all_fractions;

% ----------- Treated --------------
syllable_to_process = treated_frac_syllables;
fields = fieldnames(syllable_to_process);

% In each row, calculate the fraction of each syllable
for i = 1:length(syllable_to_process)
    total_syllables = sum(cell2mat(struct2cell(syllable_to_process(i))));
    for j = 1:length(fields)
        syllable_to_process(i).(fields{j}) = syllable_to_process(i).(fields{j}) / total_syllables;
    end
end


all_fractions = cell(length(fields),1);
for i = 1:length(syllable_to_process)
    for j = 1:length(fields)
        all_fractions{j,1} = [all_fractions{j,1} syllable_to_process(i).(fields{j})];
    end
end

all_treated_fractions = all_fractions;


% --- ANOVA ------
% Assuming you have all_treated_fractions and all_control_fractions as 5x1 cells

numSyllableTypes = 5;

% Create empty arrays to store p-values
p_values = zeros(numSyllableTypes, 1);

% Loop through each syllable type to perform ANOVA
for i = 1:numSyllableTypes
    % Combine data for treated and control for the current syllable type
    combined_data = [all_treated_fractions{i}'; all_control_fractions{i}'];
    
    % Create grouping variables
    num_treated = length(all_treated_fractions{i});
    num_control = length(all_control_fractions{i});
    groups = [ones(num_treated, 1); 2*ones(num_control, 1)];  % 1 for treated, 2 for control
    
    % Perform one-way ANOVA
    [p,~,~] = anovan(combined_data, {groups}, 'varnames', {'Treatment'}, 'display', 'on');
    
    % Store p-value (for the effect of Treatment)
    p_values(i) = p(1);
end

% Find syllable types with significant difference (e.g., at alpha = 0.05)
significant_syllables = find(p_values < 0.05);


% Display
if isempty(significant_syllables)
    disp('No syllable types show significant differences.')
else
    disp('Significant difference found in syllable types:');
    disp(significant_syllables);
    disp(fieldnames(syllable_to_process))
end
