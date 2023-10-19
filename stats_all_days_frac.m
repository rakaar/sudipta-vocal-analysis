clear;clc;

control_data = load('control_frac_syllables.mat').control_frac_syllables;
treated_data = load('treated_frac_syllables.mat').treated_frac_syllables;

syllable_type_strs = {'single', 'noise', 'jump', 'harmonic', 'other'};

for i = 1:5
    ctrl_fracs = cell2mat({control_data.(syllable_type_strs{i})});
    treated_fracs = cell2mat({treated_data.(syllable_type_strs{i})});

    disp(['-- Fraction type ' syllable_type_strs{i} ' --'])
    % ttest
    [~,p] = ttest2(ctrl_fracs, treated_fracs);
    disp(['ttest: p = ' num2str(p)])
    % ranksum
    p = ranksum(ctrl_fracs, treated_fracs);
    disp(['ranksum: p = ' num2str(p)])
    
end 