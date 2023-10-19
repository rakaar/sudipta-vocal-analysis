clear;clc;

% anovan - frac, day , ctrl/trated,
y = [];
control_data = load('control_syllables_vs_days').control_syllables_vs_days;
treated_data = load('treated_syllables_vs_days').treated_syllables_vs_days;

g1 = [];
g2 = [];
g3  = [];    

% control - g3 = 1
for f = 1:size(control_data,1)
    for d = 1:size(control_data,2)
        y = [y;control_data{f,d}];
        g1 = [g1;repmat(f,size(control_data{f,d},1),1)];
        g2 = [g2;repmat(d,size(control_data{f,d},1),1)];
        g3 = [g3;repmat(1,size(control_data{f,d},1),1)];
    end
end

% treated - g3 = 2
for f = 1:size(treated_data,1)
    for d = 1:size(treated_data,2)
        y = [y;treated_data{f,d}];
        g1 = [g1;repmat(f,size(treated_data{f,d},1),1)];
        g2 = [g2;repmat(d,size(treated_data{f,d},1),1)];
        g3 = [g3;repmat(2,size(treated_data{f,d},1),1)];
    end
end

p = anovan(y,{g1,g2,g3})

t_test_table = size(5,7); % 5 - syllables, 7 - days
ranksum_table = size(5,7); % 5 - syllables, 7 - days

% p-values t-test btn control and treated
for f = 1:size(control_data,1)
    for d = 1:size(control_data,2)
        [~,p] = ttest2(control_data{f,d},treated_data{f,d});
        t_test_table(f,d) = p;
    end
end

% ranksum
for f = 1:size(control_data,1)
    for d = 1:size(control_data,2)
        p = ranksum(control_data{f,d},treated_data{f,d});
        ranksum_table(f,d) = p;
    end
end

syllable_types = {'single', 'noise', 'jump', 'harmonic', 'other'};
% ttest
tableData = array2table(t_test_table, 'VariableNames', {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});
tableData.Properties.RowNames = syllable_types;
disp('----------T-test----------')
disp(tableData);

% ranksum
tableData = array2table(ranksum_table, 'VariableNames', {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});
tableData.Properties.RowNames = syllable_types;
disp('----------Ranksum----------')
disp(tableData);