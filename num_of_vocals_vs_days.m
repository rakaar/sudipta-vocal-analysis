clear;clc;



% Initial setup
data_path = 'F:\Treated';
% data_path = 'F:\Control';

animal_counter = 1;


all_mouse_numbers = [];
all_mouse_days = [];

% 1. Iterate through each directory in data path
dir_info = dir(data_path);
dir_info = dir_info([dir_info.isdir] & ~strcmp({dir_info.name},'.') & ~strcmp({dir_info.name},'..'));


% count number of mice and days
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

vocals_vs_days = zeros(length(unique_mouse_numbers), length(unique_mouse_days));


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
    num_vocals = size(data,1);
    
    % Convert to lowercase
    inputStr = lower(dir_info(folder).name);

    % Extract the mouse number and postnatal day number
    [mouseNum, postNatalDay] = extract_info(inputStr);

    mouse_num_index = find(mouseNum == unique_mouse_numbers);
    mouse_day_index = find(postNatalDay == unique_mouse_days);

    vocals_vs_days(mouse_num_index, mouse_day_index) = vocals_vs_days(mouse_num_index, mouse_day_index) + num_vocals;
end



% Calculate the mean and SEM for each day
mean_vocals = mean(vocals_vs_days, 1);  % Mean across mice (rows) for each day (columns)
sem_vocals = std(vocals_vs_days, 0, 1) / sqrt(size(vocals_vs_days, 1));  % SEM for each day

% Plot
figure;
errorbar(unique_mouse_days, mean_vocals, sem_vocals, 'o-', 'LineWidth', 1.5);
xlabel('Postnatal Day');
ylabel('Mean Number of Vocals');
title('Mean Number of Vocals vs. Days with Error Bars');

if contains(data_path, 'Control')
    control_vocals_vs_days = vocals_vs_days;
    save('control_vocals_vs_days.mat', 'control_vocals_vs_days');
else
    treated_vocals_vs_days = vocals_vs_days;
    save('treated_vocals_vs_days.mat', 'treated_vocals_vs_days');
end