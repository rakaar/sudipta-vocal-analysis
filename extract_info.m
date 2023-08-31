% Function to extract mouse number and postnatal day number
function [mouseNum, postNatalDay] = extract_info(inputStr)
    % Extract second character
    mouseNum = inputStr(2);
    
    % Regular expression to find postnatal day number after "controlpupsp"
    match = regexp(inputStr, 'pupsp(\d{1,2})', 'tokens');
    
    % Extract the matched number
    if ~isempty(match)
        postNatalDayFull = match{1}{1};
        
        % Check the value of postNatalDay and take only the first character if it's > 15
        if str2double(postNatalDayFull) > 15
            postNatalDay = postNatalDayFull(1);
        else
            postNatalDay = postNatalDayFull;
        end
    else
        postNatalDay = 'Not Found';
    end


    mouseNum = str2double(mouseNum);
    postNatalDay = str2double(postNatalDay);
end