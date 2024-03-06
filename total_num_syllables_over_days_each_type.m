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

    data = readtable(fullfile(current_dir, target_file));
    
    rowsToRemove = data{:, 6} < 30/1000;  % less than 30 ms
    data(rowsToRemove, :) = [];
    rowsToRemove = data{:, 6} > 350/1000;  % less than 30 ms
    data(rowsToRemove, :) = [];

    syllables_column = data{:, end-2};
    is_harmonic_column = data{:, end-1};


    for syl_index = 1:length(syllables_column)
        if is_harmonic_column(syl_index) == 1
            syllables_column{syl_index} = 'harmonic';
        end
    end

    %   % Convert to lowercase
  inputStr = lower(dir_info(folder).name);

  % Extract the mouse number and postnatal day number
  [mouseNum, postNatalDay] = extract_info(inputStr);
   
  if postNatalDay == 12
    continue
  end
  postnatal_day_index = find(postnatal_days == postNatalDay);


  each_folder_frac = zeros(5,1);
  for v = 1:size(syllables_column,1)
    syllable5 =  syllables_column{v,1};
    syllable5_index = find(strcmp(syllable_types, map_11_to_5(syllable5)));
    if isempty(syllable5_index)
        error('Syllable not found')
        return    
    end
    
    each_folder_frac(syllable5_index) = each_folder_frac(syllable5_index) + 1;
   end % v


   

   for s = 1:5
         syllables_vs_days{s, postnatal_day_index} = [syllables_vs_days{s, postnatal_day_index}; each_folder_frac(s)];
   end

    
end


if contains(data_path, 'Control')
    control_syllables_vs_days = syllables_vs_days;
    save('control_syllables_vs_days', 'control_syllables_vs_days')
elseif contains(data_path, 'Treated')
    treated_syllables_vs_days = syllables_vs_days;
    save('treated_syllables_vs_days', 'treated_syllables_vs_days')
end