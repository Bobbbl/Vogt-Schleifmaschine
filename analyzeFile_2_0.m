%% Lade Daten
filterSpec = '*.txt';
[fileName, pathName, fillterIndex] = uigetfile(filterSpec, 'Wähle dein File aus');
pathToFile = [pathName, fileName];
[Zeit,Amplitude] = importfile(pathToFile);
%% Differenziere Signal
dy = diff(Amplitude);
%% Finde Nullanstieg
null_point = [];
wval = [];
thresh = max(max(dy))/1000000;

[row, col] = find(abs(dy) < thresh);
null_point = row;

%% Finde den Ersten Peak nach Nullanstieg
wval = [];
tmp = [];
peak_index_array = nan(size(null_point));
peak_array = nan(size(null_point));
vor = 4;
danach = 4;

for i = 1:length(null_point)
    wval = null_point(i);
    
    [pks, locs] = findpeaks(Amplitude(wval:end));

end
