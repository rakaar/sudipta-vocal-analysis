clear;clc; close all;

% Initial setup

data_path = '/media/rka/Sudipta_2/Treated';
% data_path = '/media/rka/Sudipta_2/Control';

animal_counter = 1;
all_animals_struct = struct();

% 1. Iterate through each directory in data path
dir_info = dir(data_path);
dir_info = dir_info([dir_info.isdir] & ~strcmp({dir_info.name},'.') & ~strcmp({dir_info.name},'..'));

for folder = 1:length(dir_info)
    disp(['Folder num ' num2str(folder) ' out of ' num2str(length(dir_info))])
    current_dir = fullfile(data_path, dir_info(folder).name);

    % 2. Each directory represents an animal. Find the excel file that doesn't end with "_DL".
    excel_files = dir(fullfile(current_dir, '*.xlsx'));
    target_file = '';
    for i = 1:length(excel_files)
        if ~endsWith(excel_files(i).name, '_DL.xlsx')
            target_file = excel_files(i).name;
            break;
        end
    end

    if isempty(target_file)
        continue;  % move to next directory if no valid excel file is found
    end

    % Read the excel file, and get last but 2nd column. -- Excel worksheet could not be activated
    % [~,~,data] = xlsread(fullfile(current_dir, target_file));
    % syllables_column = data(2:end, end-2);

    data = readtable(fullfile(current_dir, target_file));
    rowsToRemove = data{:, 6} < 30/1000;  % less than 30 ms
    data(rowsToRemove, :) = [];

    syllables_column = data{:, end-2};
    is_harmonic_column = data{:, end-1};


    for syl_index = 1:length(syllables_column)
        if is_harmonic_column(syl_index) == 1
            syllables_column{syl_index} = 'harmonic';
        end
    end



    % 4. Now in struct make a row with field name as syllable type and value as number of such syllables in animal
    unique_syllables = unique(syllables_column);
    for i = 1:length(unique_syllables)
        syllable = unique_syllables{i};
        field_name = matlab.lang.makeValidName(syllable);  % Convert to a valid field name
        all_animals_struct(animal_counter).(field_name) = sum(strcmp(syllables_column, syllable));
    end

    % 5. increment the counter.
    animal_counter = animal_counter + 1;
end



% Make a new struct of the same rows and fields
fields = fieldnames(all_animals_struct);
fraction_animals_struct = struct();
for i = 1:length(all_animals_struct)
    for j = 1:length(fields)
        fraction_animals_struct(i).(fields{j}) = 0;
    end
end

for i = 1:length(all_animals_struct)
    animal_fields = fieldnames(all_animals_struct(i));
    for j = 1:length(animal_fields)
        if ~isempty(all_animals_struct(i).(animal_fields{j}))
            fraction_animals_struct(i).(animal_fields{j}) = all_animals_struct(i).(animal_fields{j});
        end
    end
end


% change mapping
new_all_animals_struct = struct('single', {}, 'noise', {}, 'jump', {}, 'harmonic', {}, 'other', {});

map_11_to_5 = containers.Map;
map_11_to_5('down_fm') = 'single';
map_11_to_5('flat') = 'single';
map_11_to_5('noise_dist') = 'noise';
map_11_to_5('short') = 'noise';
map_11_to_5('step_down') = 'jump';
map_11_to_5('step_up') = 'jump';
map_11_to_5('up_fm') = 'single';
map_11_to_5('mult_steps') = 'other';
map_11_to_5('two_steps') = 'other';
map_11_to_5('chevron') = 'single';
map_11_to_5('rev_chevron') = 'single';
map_11_to_5('complex') = 'single';
map_11_to_5('harmonic') = 'harmonic';


% {'single'  }
% {'noise'   }
% {'jump'    }
% {'harmonic'}
% {'other'   }
% Get number of animals
numAnimals = length(all_animals_struct);

% Initialize the new_all_animals_struct with zeros for each category for each animal
for i = 1:numAnimals
    new_all_animals_struct(i).single = 0;
    new_all_animals_struct(i).noise = 0;
    new_all_animals_struct(i).jump = 0;
    new_all_animals_struct(i).harmonic = 0;
    new_all_animals_struct(i).other = 0;
end

% Map and sum the syllables from all_animals_struct to new_all_animals_struct
for i = 1:numAnimals
    % Get fields (syllables) present for the current animal
    currentFields = fieldnames(fraction_animals_struct(i));
    
    % Iterate over each field (syllable)
    for j = 1:length(currentFields)
        currentField = currentFields{j};
        
        if isKey(map_11_to_5, currentField)
            mappedField = map_11_to_5(currentField);
            % Add the count of the current syllable to the corresponding category in new_all_animals_struct
            new_all_animals_struct(i).(mappedField) = new_all_animals_struct(i).(mappedField) + fraction_animals_struct(i).(currentField);
        end
    end
end


% =========== CHANING NAME -========
fraction_animals_struct = new_all_animals_struct;
fields = fieldnames(fraction_animals_struct);

% In each row, calculate the fraction of each syllable
for i = 1:length(fraction_animals_struct)
    total_syllables = sum(cell2mat(struct2cell(fraction_animals_struct(i))));
    for j = 1:length(fields)
        fraction_animals_struct(i).(fields{j}) = fraction_animals_struct(i).(fields{j}) / total_syllables;
    end
end


all_fractions = cell(length(fields),1);
for i = 1:length(fraction_animals_struct)
    for j = 1:length(fields)
        all_fractions{j,1} = [all_fractions{j,1} fraction_animals_struct(i).(fields{j})];
    end
end

avg_fraction = cellfun(@mean, all_fractions);
std_error = cellfun(@std, all_fractions) / sqrt(length(fraction_animals_struct));





figure;
bar(avg_fraction);
hold on;
errorbar(1:length(fields), avg_fraction, std_error, 'k.', 'linewidth', 2);
hold off;
set(gca, 'XTick', 1:length(fields), 'XTickLabel', fields, 'XTickLabelRotation', 45);
ylabel('Average Fraction');
title(['Average Fraction of Each Syllable Across Animals - ' data_path]);

if contains(data_path, 'Control')
    control_frac_syllables = fraction_animals_struct;
    save('control_frac_syllables', 'control_frac_syllables')
else
    treated_frac_syllables = fraction_animals_struct;
    save('treated_frac_syllables', 'treated_frac_syllables')
end