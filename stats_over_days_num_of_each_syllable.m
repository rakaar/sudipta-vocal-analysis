control_data = load('control_syllables_vs_days_each_type').syllables_vs_days;
treated_data = load('treated_syllables_vs_days_each_type').syllables_vs_days;
syllable_types = {'single', 'noise', 'jump', 'harmonic', 'other'};
data = control_data;

for s = 1:5
    figure
    % cellfun mean of data(s,:)
    bar(cellfun(@mean, data(s,:)))
    title([' Contro l' syllable_types{s} ' syllables'])
end

data = treated_data;

for s = 1:5
    figure
    % cellfun mean of data(s,:)
    bar(cellfun(@mean, data(s,:)))
    title([' Treated' syllable_types{s} ' syllables'])
end