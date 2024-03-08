control_db = load('control_database').the_database;
treated_db = load('treated_database').the_database;

control_57 = make_cell(control_db);
treated_57 = make_cell(treated_db);

map_5_to_num = containers.Map;
map_5_to_num('single') = 1;
map_5_to_num('noise') = 2;
map_5_to_num('jump') = 3;
map_5_to_num('harmonic') = 4;   
map_5_to_num('other') = 5; 

all_sy_strings = {'single', 'noise', 'jump', 'harmonic', 'other'};

for syllableType = 1:5 % For each syllable type
    figure; % Create a new figure for each syllable type
    hold on; % Hold on to plot everything on the same figure
    
    controlMeans = zeros(1, 7);
    treatedMeans = zeros(1, 7);
    controlSE = zeros(1, 7); % Standard Error for control
    treatedSE = zeros(1, 7); % Standard Error for treated
    controlLength = zeros(1, 7); % To store non-NaN lengths for control
    treatedLength = zeros(1, 7); % To store non-NaN lengths for treated
    
    % Calculate means and standard errors
    for dayIndex = 1:7
        controlData = control_57{syllableType, dayIndex};
        treatedData = treated_57{syllableType, dayIndex};
        
        controlMeans(dayIndex) = nanmean(controlData);
        treatedMeans(dayIndex) = nanmean(treatedData);
        
        % Calculating standard errors, considering non-NaN counts
        controlLength(dayIndex) = sum(~isnan(controlData));
        treatedLength(dayIndex) = sum(~isnan(treatedData));
        
        controlSE(dayIndex) = nanstd(controlData) / sqrt(controlLength(dayIndex));
        treatedSE(dayIndex) = nanstd(treatedData) / sqrt(treatedLength(dayIndex));
    end
    
    % Plotting grouped bars
    x = 1:7;
    bar(x-0.15, controlMeans, 0.3, 'FaceColor', 'k'); % Black for control
    bar(x+0.15, treatedMeans, 0.3, 'FaceColor', [0.5 0.5 0.5]); % Grey for treated
    
    % Adding error bars
    errorbar(x-0.15, controlMeans, controlSE, 'k', 'linestyle', 'none');
    errorbar(x+0.15, treatedMeans, treatedSE, 'k', 'linestyle', 'none');
    
    % Plotting individual data points
    for dayIndex = 1:7
        controlData = control_57{syllableType, dayIndex};
        treatedData = treated_57{syllableType, dayIndex};
        
        scatter(ones(1, length(controlData))*(dayIndex-0.15), controlData, 'b', 'filled'); % Blue dots for control
        scatter(ones(1, length(treatedData))*(dayIndex+0.15), treatedData, 'r', 'filled'); % Red dots for treated
    end
    
    % Aesthetic adjustments
    set(gca, 'xtick', 1:7, 'xticklabel', {'P5', 'P6', 'P7', 'P8', 'P9', 'P10', 'P11'}); % Set x-axis ticks and labels
    ylabel('Number of Syllables'); % y-axis label
    
    title([' Syllable ' all_sy_strings{syllableType} ' '])
    legend('Control', 'Treated', 'Location', 'Best'); % Legend
    hold off;
    saveas(gcf, ['Mean_num_2_Syllable ' all_sy_strings{syllableType} '.fig'])
end




function simplified_cell = make_cell(db)
    simplified_cell = cell(5,7);
    for i = 1:5
        for j = 1:7
            simplified_cell{i,j} = nan(size(db,2),1);
        end
    end
    for a = 1:size(db,2)
        disp(['Animal ' num2str(a)])
        for day = 1:7
            disp(['Day ' num2str(day)])
            cell_val = db{day, a};
            if isempty(cell_val)
                continue
            end

            sylls = cell_val(:,1);
            for sy = 1:5
                
                current_arr = simplified_cell{sy,day}; % n_animals x 1
                
                if isnan(current_arr(a))
                    current_arr(a) = 0;
                end

                current_arr(a) = current_arr(a) + sum(sylls == sy);
                
                simplified_cell{sy,day} = current_arr;
                
            end

            
        end
    end
end