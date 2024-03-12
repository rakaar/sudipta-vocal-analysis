function filtered_arr = filter_30_and_350(original_arr)
    removed_indices = [];
    for i = 1:size(original_arr,1)
        durn = original_arr(i,2);
        if durn < 30/1000 || durn > 350/1000
            removed_indices = [removed_indices; i];
        end
    end

    % filtered array is n x 2 matrix
    % remove removed_indices from filter_arr
    % TODO
    filtered_arr = original_arr;
    filtered_arr(removed_indices, :) = [];
end