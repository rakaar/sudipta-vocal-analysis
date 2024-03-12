clear;close all;clc;

control_db = load('control_database').the_database;
treated_db = load('treated_database').the_database;

map_5_to_num = containers.Map;
map_5_to_num('single') = 1;
map_5_to_num('noise') = 2;
map_5_to_num('jump') = 3;
map_5_to_num('harmonic') = 4;   
map_5_to_num('other') = 5; 


% map_num_to_name = containers.Map;
% map_num_to_name(1) = 'single';
% map_num_to_name(2) = 'noise';
% map_num_to_name(3) = 'jump';
% map_num_to_name(4) = 'harmonic';
% map_num_to_name(5) = 'other';



control_day_vs_cell = make_day_v_sy_cell(control_db);
treated_day_vs_cell = make_day_v_sy_cell(treated_db);

function day_vs_syllable_cell = make_day_v_sy_cell(db)
    day_vs_syllable_cell = cell(5,7);

    for s = 1:5
        
        for d = 1:7
            for a = 1:size(db,2)
                syllable_durn_with_type = db{d,a};
                if isempty(syllable_durn_with_type)
                    continue;
                end

                syll_types = syllable_durn_with_type(:,1);
                num_s_type = sum(syll_types == s);
                day_vs_syllable_cell{s,d} = [day_vs_syllable_cell{s,d}; num_s_type];
            end    
        end
    end
    
end