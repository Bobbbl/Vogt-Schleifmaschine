function [Zeit,Amplitude] = importfile(filename, startRow, endRow)


%% Initialize variables.
delimiter = {'\t',' '};
delimiter = '\t ';
if nargin<=2
    startRow = 1;
    endRow = inf;
end


formatSpec = '%*s%s%*s%*s%*s%s%[^\n\r]';


fileID = fopen(filename,'r');


dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

fclose(fileID);


raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));



rawData = dataArray{2};
for row=1:size(rawData, 1);
    % Create a regular expression to detect and remove non-numeric prefixes and
    % suffixes.
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\.]*)+[\,]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\.]*)*[\,]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData{row}, regexstr, 'names');
        numbers = result.numbers;
        
        % Detected commas in non-thousand locations.
        invalidThousandsSeparator = false;
        if any(numbers=='.');
            thousandsRegExp = '^\d+?(\.\d{3})*\,{0,1}\d*$';
            if isempty(regexp(thousandsRegExp, '.', 'once'));
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Convert numeric strings to numbers.
        if ~invalidThousandsSeparator;
            numbers = strrep(numbers, '.', '');
            numbers = strrep(numbers, ',', '.');
            numbers = textscan(numbers, '%f');
            numericData(row, 2) = numbers{1};
            raw{row, 2} = numbers{1};
        end
    catch me
    end
end



rawNumericColumns = raw(:, 2);
rawCellColumns = raw(:, 1);



R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); 
rawNumericColumns(R) = {NaN};


Zeit = rawCellColumns(:, 1);
Amplitude = cell2mat(rawNumericColumns(:, 1));


