clear; clc; close all;

control_3d_cell = load('control_3d_cell').control_3d_cell;
treated_3d_cell = load('treated_3d_cell').treated_3d_cell;

% 7 days x n animals x 5 syllables
control_5 = make_5(control_3d_cell);
treated_5 = make_5(treated_3d_cell);

% Number of syllable types
numSyllableTypes = size(control_5, 1);

% Pre-allocate arrays for means, standard deviations, and standard errors
meansControl = zeros(numSyllableTypes, 1);
semsControl = zeros(numSyllableTypes, 1);
meansTreated = zeros(numSyllableTypes, 1);
semsTreated = zeros(numSyllableTypes, 1);

% Calculate means and standard errors for each syllable type
for i = 1:numSyllableTypes
    meansControl(i) = mean(control_5{i, 1});
    stdsControl = std(control_5{i, 1});
    semsControl(i) = stdsControl / sqrt(length(control_5{i, 1}));
    meansTreated(i) = mean(treated_5{i, 1});
    stdsTreated = std(treated_5{i, 1});
    semsTreated(i) = stdsTreated / sqrt(length(treated_5{i, 1}));
end

% Grouped bar plot
fig = figure;
b = bar(1:numSyllableTypes, [meansControl, meansTreated], 'grouped');
hold on;

% Error bars
ngroups = size([meansControl, meansTreated], 1);
nbars = size([meansControl, meansTreated], 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:numSyllableTypes) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    if i == 1
        errorbar(x, meansControl, semsControl, 'k.', 'linewidth', 1.5);
    else
        errorbar(x, meansTreated, semsTreated, 'k.', 'linewidth', 1.5);
    end
end

% Scatter plot for individual data points
colors = {'blue', 'red'}; % Control: blue, Treated: red
for i = 1:numSyllableTypes
    scatter(repmat(i-0.15, size(control_5{i,1}, 1), 1), control_5{i,1}, 'MarkerEdgeColor', colors{1}, 'MarkerFaceColor', colors{1});
    scatter(repmat(i+0.15, size(treated_5{i,1}, 1), 1), treated_5{i,1}, 'MarkerEdgeColor', colors{2}, 'MarkerFaceColor', colors{2});
end

% Set bar colors
b(1).FaceColor = 'k'; % Control: black
b(2).FaceColor = [0.5 0.5 0.5]; % Treated: gray

% Customize x-axis ticks
xticks(1:5);
% map_5_to_num('single') = 1;
% map_5_to_num('noise') = 2;
% map_5_to_num('jump') = 3;
% map_5_to_num('harmonic') = 4;   
% map_5_to_num('other') = 5; 
xticklabels({'single', 'noise', 'jump', 'harmonic', 'other'});

% Labels and Legend
xlabel('Syllable Type');
ylabel('Mean Number of Syllables');
legend({'Control', 'Treated'}, 'Location', 'Best');
hold off;

all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};
for s = 1:5
    disp(['type - ' all_s{s}])
    [h,p] = ttest2(control_5{s,1}, treated_5{s,1});
    disp(['Ttest: h = ' num2str(h) ' p = ' num2str(p) ])
    [p,h] = ranksum(control_5{s,1}, treated_5{s,1});
    disp(['ranksum: h = ' num2str(h) ' p = ' num2str(p)])
end

function db_5 = make_5(db)
    db_5 = cell(5,1);

    for s = 1:5
        days_animal_cell = db(:,:,s);
        days_animal_len_mat = nan(size(days_animal_cell,1), size(days_animal_cell,2)); 
        for i = 1:size(days_animal_cell,1) % 7 days
            for j = 1:size(days_animal_cell,2)
                if ~isempty(days_animal_cell{i,j})
                    days_animal_len_mat(i,j) = length(days_animal_cell{i,j});
                end
            end
        end

      summed_days_animal_len =  nansum(days_animal_len_mat, 1);
      db_5{s,1} = summed_days_animal_len;
    end
end 



