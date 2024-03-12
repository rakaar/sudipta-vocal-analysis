
control_sum5 = make_sum_cell(control_57);
treated_sum5 = make_sum_cell(treated_57);
function sum_cell = make_sum_cell(db)
    sum_cell = cell(5,1);
for s = 1:5
    all_animal_s = db{s,1};
    all_animal_s(find(isnan(all_animal_s))) = 0;
    for d = 2:7
       all_animal_s = all_animal_s +  db{s,d};
    end

    sum_cell{s,1} = all_animal_s;
end
end