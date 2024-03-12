clear;clc;close all;

control_3d_cell = load('control_3d_cell').control_3d_cell;
treated_3d_cell = load('treated_3d_cell').treated_3d_cell;

% 7 x a x 5
all_s = {'single', 'noise', 'jump', 'harmonic', 'other'};


for s = 1:5
    cont_syl_7 = make_7(control_3d_cell, s);
    treated_syl_7 = make_7(treated_3d_cell, s);

    % Pre-allocate arrays for means, standard deviations, and standard errors
meansControl = zeros(7, 1);
semsControl = zeros(7, 1);
meansTreated = zeros(7, 1);
semsTreated = zeros(7, 1);

% Calculate means and standard errors for each syllable type
for i = 1:7
    meansControl(i) = nanmean(cont_syl_7{i, 1});
    stdsControl = nanstd(cont_syl_7{i, 1});
    semsControl(i) = stdsControl / sqrt(sum(~isnan(cont_syl_7{i, 1})));
    meansTreated(i) = nanmean(treated_syl_7{i, 1});
    stdsTreated = nanstd(treated_syl_7{i, 1});
    semsTreated(i) = stdsTreated / sqrt(sum(~isnan(treated_syl_7{i, 1})));
end

% Grouped bar plot
fig = figure;
b = bar(1:7, [meansControl, meansTreated], 'grouped');
hold on;

% Error bars
ngroups = size([meansControl, meansTreated], 1);
nbars = size([meansControl, meansTreated], 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
num_days = 7;
for i = 1:nbars
    x = (1:num_days) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    if i == 1
        errorbar(x, meansControl, semsControl, 'k.', 'linewidth', 1.5);
    else
        errorbar(x, meansTreated, semsTreated, 'k.', 'linewidth', 1.5);
    end
end

% Scatter plot for individual data points
colors = {'blue', 'red'}; % Control: blue, Treated: red
for i = 1:num_days
    scatter(repmat(i-0.15, size(cont_syl_7{i,1}, 1), 1), cont_syl_7{i,1}, 'MarkerEdgeColor', colors{1}, 'MarkerFaceColor', colors{1});
    scatter(repmat(i+0.15, size(treated_syl_7{i,1}, 1), 1), treated_syl_7{i,1}, 'MarkerEdgeColor', colors{2}, 'MarkerFaceColor', colors{2});
end

% Set bar colors
b(1).FaceColor = 'k'; % Control: black
b(2).FaceColor = [0.5 0.5 0.5]; % Treated: gray

% Customize x-axis ticks
xticks(1:7);
% map_5_to_num('single') = 1;
% map_5_to_num('noise') = 2;
% map_5_to_num('jump') = 3;
% map_5_to_num('harmonic') = 4;   
% map_5_to_num('other') = 5; 
xticklabels({'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'});

% Labels and Legend
xlabel('Day');
ylabel('Mean Number of Syllables');
legend({'Control', 'Treated'}, 'Location', 'Best');
title(all_s{s})
hold off;
saveas(gcf, ['Mean_over_days_for_' all_s{s} '.fig'])

disp(['Syllable TYPE ' all_s{s}])
for ddd = 1:7
    disp(['Day P ' num2str(ddd + 4)])
    control_d1 = cont_syl_7{ddd,1};
    treated_d1 = treated_syl_7{ddd,1};
    
    [h,p] = ttest2(control_d1, treated_d1);
    disp(['TTest : h ='  num2str(h) ' p = ' num2str(p)])

    try
        [p,h] = ranksum(control_d1, treated_d1);
        disp(['Ranksum: h = ' num2str(h) ' p = ' num2str(p) ])
    catch exception
        disp(['Ranksum error: ' exception.message]);
    end
end

end

function db_7 = make_7(db,s_num)
    db_7 = cell(7,1);

    
        days_animal_cell = db(:,:,s_num);
        n_days = size(days_animal_cell,1);
        n_animals = size(days_animal_cell,2);

        for a = 1:n_animals
            for d = 1:n_days
                if isempty(days_animal_cell{d,a})
                    db_7{d,1} = [db_7{d,1}; nan];

                else
                    db_7{d,1} = [db_7{d,1}; length(days_animal_cell{d,a})];
                end
            end
        end
    
end 