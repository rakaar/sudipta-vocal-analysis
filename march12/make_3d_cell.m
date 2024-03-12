clear; clc; close all;

% days x animals
control_db = load('control_database').the_database;
treated_db = load('treated_database').the_database;

control_filter_db = remove_30_350_in_db(control_db);
treated_filter_db = remove_30_350_in_db(treated_db);

save('control_filter_db', 'control_filter_db')
save('treated_filter_db', 'treated_filter_db')


control_3d_cell = cell_3d_from_filter_db(control_filter_db);
treated_3d_cell = cell_3d_from_filter_db(treated_filter_db);

save('control_3d_cell', 'control_3d_cell')
save('treated_3d_cell', 'treated_3d_cell')

% 7 days x n_animals x syllable_types
function cell_3d = cell_3d_from_filter_db(db)
    n_animals = size(db,2);
    cell_3d = cell(7, n_animals, 5);

    for a = 1:n_animals
        for day = 1:7
            durn_type_mat = db{day,a};
            if isempty(durn_type_mat)
                continue
            end

            for s = 1:5
                syl_type_vec = durn_type_mat(:,1);
                durns_of_syl_type_vec = durn_type_mat(:,2);
                
                s_type_indices = find(syl_type_vec == s);
                durns_of_only_s_type = durns_of_syl_type_vec(s_type_indices);
                cell_3d{day, a, s} = [cell_3d{day, a, s}; durns_of_only_s_type];
            end

        end
    end

end
function filter_db = remove_30_350_in_db(db)
    filter_db = cell(size(db,1), size(db,2));
    for i = 1:size(db,1)
        for j = 1:size(db,2)
            mat_type_durn = db{i,j};
            if isempty(mat_type_durn)
                continue
            end

            filter_db{i,j} = filter_30_and_350(mat_type_durn);
        end
    end
end