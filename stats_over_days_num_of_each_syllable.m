control_data = load('control_syllables_vs_days_each_type').syllables_vs_days;
treated_data = load('treated_syllables_vs_days_each_type').syllables_vs_days;
syllable_types = {'single', 'noise', 'jump', 'harmonic', 'other'};
data = control_data;

for s = 1:5
    figure
    % cellfun mean of data(s,:)
    vec = cellfun(@mean, data(s,:));
    bar(vec)
    title([' Contro l' syllable_types{s} ' syllables'])
   
    disp(['Control ' syllable_types{s} ' syllables' ])
    % fit a line to vec vector and see if the slope is signifcantly greater than 0 or not
    x = (1:length(vec))';
    y = vec';
    lm = fitlm(x, y);

    % Get the p-value for the slope (the second coefficient)
pValue = lm.Coefficients.pValue(2);

slopeValue = lm.Coefficients.Estimate(2);
disp(['Slope = ', num2str(slopeValue)]);






% Display the p-value
disp(['p-value for slope = ', num2str(pValue)]);



end

disp('====================================')

data = treated_data;

for s = 1:5
    figure
    % cellfun mean of data(s,:)
    vec = cellfun(@mean, data(s,:));
    bar(vec)
    title([' Treated' syllable_types{s} ' syllables'])

    disp(['Treated ' syllable_types{s} ' syllables' ])
    % fit a line to vec vector and see if the slope is signifcantly greater than 0 or not
    x = (1:length(vec))';
    y = vec';
    lm = fitlm(x, y);

    % Get the p-value for the slope (the second coefficient)
pValue = lm.Coefficients.pValue(2);

slopeValue = lm.Coefficients.Estimate(2);
disp(['Slope = ', num2str(slopeValue)]);





% Display the p-value
disp(['p-value for slope = ', num2str(pValue)]);

end
close all;