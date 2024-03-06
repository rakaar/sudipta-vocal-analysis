% A histogram of all syllable durations
clear;clc;
% Initial setup
% data_path = '/media/rka/Sudipta_2/Control';
data_path = '/media/rka/Sudipta_2/Treated';
animal_counter = 1;
all_animals_struct = struct();

all_syllable_durations = [];

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


map_type_to_durn = containers.Map;
map_type_to_durn('single') = [];
map_type_to_durn('noise') = [];
map_type_to_durn('jump') = [];
map_type_to_durn('other') = [];
map_type_to_durn('harmonic') = [];

% 1. Iterate through each directory in data path
dir_info = dir(data_path);
dir_info = dir_info([dir_info.isdir] & ~strcmp({dir_info.name},'.') & ~strcmp({dir_info.name},'..'));

for folder = 1:length(dir_info)
    current_dir = fullfile(data_path, dir_info(folder).name);
    disp(['Processing ' num2str(folder) ' out of ' num2str(length(dir_info)) ' folders.'])

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

    inputStr = lower(dir_info(folder).name);

    % Extract the mouse number and postnatal day number
    [mouseNum, postNatalDay] = extract_info(inputStr);
    
    if postNatalDay == 12
        disp('Came here')
        continue
    end

    % if contains(data_path, 'Control')
    %     if mouseNum == 1 && postNatalDay == 5
    %         continue
    %     end
    % end

    % Read the excel file, and get last but 2nd column.
    data = readtable(fullfile(current_dir, target_file));
    all_syllable_durations = [all_syllable_durations; data{2:end,6}];

    for d = 1:size(data,1)
        syllable_durn = data{d,6};
        is_harmonic = data{d,20};
        if is_harmonic == 1
            current_durns = map_type_to_durn('harmonic');
            map_type_to_durn('harmonic') = [current_durns; syllable_durn];
        else
            syllable_type = string(data{d,19});

            syllable_type = map_11_to_5(syllable_type);
            current_durns = map_type_to_durn(syllable_type);
            map_type_to_durn(syllable_type) = [current_durns; syllable_durn];
        end
    end
end

% all_5_types = {'single', 'noise', 'jump', 'other', 'harmonic'};
all_5_types = {'single', 'noise'};

for i = 1:length(all_5_types)
    figure
        histogram(map_type_to_durn(all_5_types{i}).*1000, 'BinWidth', 10, 'BinLimits', [0, 300])
        title([all_5_types{i} '  -- ' data_path ])
        xlabel('Duration (ms)')
        ylabel('Count')

end