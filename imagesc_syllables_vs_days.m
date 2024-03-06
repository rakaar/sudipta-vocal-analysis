clear;clc;
control_syllables_vs_days = load('control_syllables_vs_days.mat').control_syllables_vs_days;
treated_syllables_vs_days = load('treated_syllables_vs_days.mat').treated_syllables_vs_days;

postnatal_days = 5:11;
syllable_type_strs = {'single', 'noise', 'jump', 'harmonic', 'other'};

% apply mean to control_syllables_vs_days and treated_syllables_vs_days using cellfun
control_syllables_vs_days_mean = cellfun(@(x) mean(x), control_syllables_vs_days, 'UniformOutput', false);
treated_syllables_vs_days_mean = cellfun(@(x) mean(x), treated_syllables_vs_days, 'UniformOutput', false);


% imagesc for control_syllables_vs_days_mean and treated_syllables_vs_days_mean
figure;
subplot(1,2,1);
imagesc(cell2mat(control_syllables_vs_days_mean)');
ylabel('Postnatal days');
xlabel('Syllable type');
title('Control');
set(gca, 'XTick', 1:5, 'XTickLabel', syllable_type_strs);
set(gca, 'YTick', 1:7, 'YTickLabel', postnatal_days);
colorbar;
clim([0 0.8]);

subplot(1,2,2);
imagesc(cell2mat(treated_syllables_vs_days_mean)');
ylabel('Postnatal days');
xlabel('Syllable type');
title('Treated');
set(gca, 'XTick', 1:5, 'XTickLabel', syllable_type_strs);
set(gca, 'YTick', 1:7, 'YTickLabel', postnatal_days);
colorbar;
clim([0 0.8]);

