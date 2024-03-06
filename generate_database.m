% Each day compare frac of syllables
clear;clc;


postnatal_days = 5:11;
syllable_types = {'single', 'noise', 'jump', 'harmonic', 'other'};
syllables_vs_days = cell(length(syllable_types), length(postnatal_days));


% data_path = '/media/rka/Sudipta_2/Treated';
data_path = '/media/rka/Sudipta_2/Control';

animal_counter = 1;
all_animals_struct = struct();


% 1. Iterate through each directory in data path
dir_info = dir(data_path);
dir_info = dir_info([dir_info.isdir] & ~strcmp({dir_info.name},'.') & ~strcmp({dir_info.name},'..'));
% count number of mice and days
all_mouse_numbers = []; all_mouse_days = [];
for folder = 1:length(dir_info)
    disp(['Folder num ' num2str(folder) ' out of ' num2str(length(dir_info))])
    current_dir = fullfile(data_path, dir_info(folder).name);

    % Convert to lowercase
    inputStr = lower(dir_info(folder).name);

    % Extract the mouse number and postnatal day number
    [mouseNum, postNatalDay] = extract_info(inputStr);

   all_mouse_numbers = [all_mouse_numbers; mouseNum];
    all_mouse_days = [all_mouse_days; postNatalDay];
end 

unique_mouse_numbers = unique(all_mouse_numbers);
unique_mouse_days = unique(all_mouse_days);


the_database = cell(length(unique_mouse_days), length(unique_mouse_numbers));
for i = 1:length(unique_mouse_days)
    for j = 1:length(unique_mouse_numbers)
        the_database{i,j} = cell(2,1);
    end
end 


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

% syllable to number map
map_5_to_num = containers.Map;
map_5_to_num('single') = 1;
map_5_to_num('noise') = 2;
map_5_to_num('jump') = 3;
map_5_to_num('harmonic') = 4;   
map_5_to_num('other') = 5; 


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

    % if isempty(target_file)
    %     continue;  % move to next directory if no valid excel file is found
    % end

    % disp(fullfile(current_dir, target_file))
    if isempty(target_file)
        disp(current_dir)
        continue
    end

      %   % Convert to lowercase
        inputStr = lower(dir_info(folder).name);

    % Extract the mouse number and postnatal day number
    [mouseNum, postNatalDay] = extract_info(inputStr);
   if postNatalDay == 12
    continue
   end
        
    postnatal_day_index = find(postnatal_days == postNatalDay);
    animal_index = find(unique_mouse_numbers == mouseNum);


    cell_block = the_database{postnatal_day_index, animal_index};
    current_types = cell_block{1,1};
    current_durns = cell_block{2,1};

    data = readtable(fullfile(current_dir, target_file));
    
    
    for d = 1:size(data,1)
        syllable_durn = data{d,6};
        current_durns = [current_durns; syllable_durn];
        
        is_harmonic = data{d,20};
        if is_harmonic == 1
            syllable_type = 'harmonic';
        else
            syllable_type = string(data{d,19});
            syllable_type = map_11_to_5(syllable_type);
        end

        syllable_index = map_5_to_num(syllable_type);
        current_types = [current_types; syllable_index];

        cell_block{1,1} = current_types;
        cell_block{2,1} = current_durns;

        the_database{postnatal_day_index, animal_index} = cell_block;


    end

   
end


% convert each cell to a matrix in the_database
for i = 1:length(unique_mouse_days)
    for j = 1:length(unique_mouse_numbers)
        the_database{i,j} = cell2mat(the_database{i,j}');
    end
end

if contains(data_path, 'Control')
    save('control_database.mat', 'the_database');
elseif contains(data_path, 'Treated')
    save('treated_database.mat', 'the_database');
end