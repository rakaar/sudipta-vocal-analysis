% A histogram of all syllable durations
clear;clc
% Initial setup
data_path = '/media/rka/Sudipta_2/Control';
animal_counter = 1;
all_animals_struct = struct();

all_syllable_durations = [];

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

    % Read the excel file, and get last but 2nd column.
    data = readtable(fullfile(current_dir, target_file));
    all_syllable_durations = [all_syllable_durations; data{2:end,6}];

end


figure
    histogram(all_syllable_durations.*1000)
    title('All syllable durations')
    xlabel('Syllable duration (ms)')
    ylabel('Probability')