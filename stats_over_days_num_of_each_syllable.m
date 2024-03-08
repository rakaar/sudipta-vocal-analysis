control_data = load('control_syllables_vs_days_each_type').syllables_vs_days;
treated_data = load('treated_syllables_vs_days_each_type').syllables_vs_days;
syllable_types = {'single', 'noise', 'jump', 'harmonic', 'other'};
data = control_data;
control_5_7 = zeros(5, 7);  
for s = 1:5
    figure
    % cellfun mean of data(s,:)
    vec = cellfun(@mean, data(s,:));
    control_5_7(s,:) = vec;
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

disp(['Mean of vec = ' num2str(mean(vec))])
disp(['median of vec = ' num2str(median(vec))])
disp('+++++')


end

disp('====================================')

data = treated_data;
treated_5_7 = zeros(5, 7);
for s = 1:5
    figure
    % cellfun mean of data(s,:)
    vec = cellfun(@mean, data(s,:));
    treated_5_7(s,:) = vec;
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
disp(['Mean of vec = ' num2str(mean(vec))])
disp(['median of vec = ' num2str(median(vec))])
disp('+++++')
end
close all;




for s = 1:5
    [h,p] = ttest2(control_5_7(s,:), treated_5_7(s,:));
    disp(['ttest2-p-value for ' syllable_types{s} ' syllables = ' num2str(p)])

    [p,h] = ranksum(control_5_7(s,:), treated_5_7(s,:));
    disp(['rankssum-p-value for ' syllable_types{s} ' syllables = ' num2str(p)])
end




for s = 1:5
    disp(['Syllable type is ' syllable_types{s}])
   vec = control_5_7(s,:) - treated_5_7(s,:);
   x = (1:length(vec))';
   y = vec';
   lm = fitlm(x, y);

   % Get the p-value for the slope (the second coefficient)
pValue = lm.Coefficients.pValue(2);

slopeValue = lm.Coefficients.Estimate(2);
disp(['Slope = ', num2str(slopeValue)]);





% Display the p-value
disp(['p-value for slope = ', num2str(pValue)]);
disp(['Mean of vec = ' num2str(mean(vec))])
disp(['median of vec = ' num2str(median(vec))])
disp('===')
end