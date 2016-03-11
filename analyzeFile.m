%% File Laden
filterSpec = '*.txt';
[fileName, pathName, fillterIndex] = uigetfile(filterSpec, 'Wähle dein File aus');
pathToFile = [pathName, fileName];
[Zeit,Amplitude] = importfile(pathToFile);
%% Lösche Datenpunkte, in denen keine Messung stattfindet
%finde den ersten Anstieg
indexStart = FindBeginningOfMeasurement(Amplitude);
indexStart = indexStart - 10;   %Sonst finden wir die Peaks nicht mehr. Man könnte
                                %hingehen, und den Index vor und nachher
                                %einfach einfügen aber so ist es einfacher

%finde das ende der Messung
indexEnd = FindEndOfMeasurement(Amplitude);
indexEnd = indexEnd + 10;       %Sonst finden wir die Peaks nicht mehr. Man könnte 
                                %hingehen, und den Index vor und nachher
                                %einfach einfügen aber so ist es einfacher

%Lösche alle Daten davor
len = length(Amplitude); %Speichere die Länge des Vektors, bevor er gekürzt wird
                         %um später entsprechende Anpassungen zu machen
Amplitude_K = Amplitude;
Amplitude_K(1:indexStart) = [];

%Lösche alle Daten danach
indexEnd = indexEnd - (len - length(Amplitude_K));  %Passe den Index an 
                                                    %Der Vektor ist jetzt
                                                    %kürzer
Amplitude_K(indexEnd:end) = [];

%% Löse die Einarbeitung heraus

global th 
th = 5e-4;




[pk, lc] = findpeaks(Amplitude_K);
[pkt, lct] = findpeaks(Amplitude_K, 'Threshold', 5e-4);

ind = [];

for i=1:length(lct)
    [row, col] = find(lc == lct(i));
    for j=1:length(row)
        ind = [ind, row(j)];
    end
end

%% Löse die Längenänderung heraus
ind_l = [];
pos_l = [];
tog = false;
for i=1:length(lc)
    tmp = lc(i);
    for j=1:length(lct)
        if tmp == lct(j)
            tog = true;
        end
    end
    
    if ~tog
        ind_l = [ind_l, tmp];
        pos_l = [pos_l, pk(i)];
    else
        tog = false;
    end
end
plot(Amplitude_K)
hold on
plot(lc, pk, 'x')
plot(ind_l, pos_l, 'o')

[x,y]=ginput(1);

[row, col] = find(pos_l < y);
pos_l(col) = [];
ind_l(col) = [];

close all;

plot(Amplitude_K)
hold on
plot(lc, pk, 'x')
plot(ind_l, pos_l, 'o')

close all;

valt = true;

while valt
    h = plot(ind_l, pos_l, 'o');
    [x,y] = ginput;
    for i = 1 : length(x)
        [cv, row, col] = findNearestValueInMatrix(pos_l, y(i));
        ind_l(col) = [];
        pos_l(col) = [];
    end
    
    plot(gca, ind_l, pos_l, 'o');
    button = questdlg('Fertig Christian?', 'OK');

    switch button
        case 'Yes'
            valt = false;
        case 'No'
            valt = true;
        otherwise
            valt = false;
    end
end

close all;

% plot(ind_l, pos_l, 'o');

%% Hole Verlaufsdaten

global prom
global f
global ax
global lctg
global pktg
global Amplitude_Kg


tmp = pkt;
lctg = lct;
pktg = pkt;

prom = 0;

Amplitude_Kg = Amplitude_K;

f = figure;
set(f, 'WindowButtonDownFcn', @FigureCallback)
% set(f, 'WindowStyle', 'modal');
ax = axes('Parent', f, 'position', [0.13 0.39  0.77 0.54]);
plot(ax, lct, pkt, 'x');
hold on
hold off

b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',0, 'min',0, 'max',20e-4);

set(b, 'Callback', @SliderCallback);

c = uicontrol('Parent',f,'Style','pushbutton','Position',[81,30,419,23], 'String', 'OK');

set(c, 'Callback', @ButtonCallback);
h = brush;
set(h, 'Enable', 'on');
waitfor(f);

%% Daten aufbereiten
%Längendaten und Verlaufsdaten
Verlauf_y = pktg';
Verlauf_x = lctg';   %Das sind eigentlich die Indizes
Laenge_x = ind_l';
Laenge_y = pos_l';

% TVerlauf = table(Verlauf_x, Verlauf_y);
% TLaenge = table(Laenge_x, Laenge_y);

%% Zeit wandeln
f = [3600, 60, 1];
r = datevec(Zeit);
r = r(:, 4:6);
t_Verlauf = r(lctg, :);
t_Laenge = r(ind_l,:);
%% Excel-File erstellen
written = false;

if isunix && ~written
     FilterSpec = '*.csv';
    [FileName,PathName,FilterIndex] = uiputfile(FilterSpec,'Vogt -> Excel');
    filename_Verlauf = [PathName, [FileName(1:end-4), '_Verlauf', FileName(end-4:end)]];
    filename_Laenge = [PathName, [FileName(1:end-4), '_Laenge', FileName(end-4:end)]];
    Stunden  = t_Verlauf(:,1);
    Minuten  = t_Verlauf(:,2);
    Sekunden = t_Verlauf(:,3);
    Zeit_Original = Zeit(lctg);
    TVerlauf = table(Stunden, Minuten, Stunden,  Zeit_Original, Verlauf_y);
    writetable(TVerlauf, filename_Verlauf, 'Delimiter', ';');
    Stunden  = t_Laenge(:,1);
    Minuten  = t_Laenge(:,2);
    Sekunden = t_Laenge(:,3);
    Zeit_Original = Zeit(ind_l);
    TLaenge = table(Stunden, Minuten, Sekunden,  Zeit_Original, Laenge_y);
    writetable(TLaenge, filename_Laenge, 'Delimiter', ';');
    written = true;
elseif ismac && ~written
     FilterSpec = '*.csv';
    [FileName,PathName,FilterIndex] = uiputfile(FilterSpec,'Vogt -> Excel');
    filename_Verlauf = [PathName, [FileName(1:end-4), '_Verlauf', FileName(end-4:end)]];
    filename_Laenge = [PathName, [FileName(1:end-4), '_Laenge', FileName(end-4:end)]];
    writetable(TVerlauf, filename_Verlauf, 'Delimiter', ';');
    writetable(TLaenge, filename_Laenge, 'Delimiter', ';');
    written = true;
else
%     FilterSpec = '*.xlsx';
%     [FileName,PathName,FilterIndex] = uiputfile(FilterSpec,'Vogt -> Excel');
%     filename = [PathName, FileName];
%     writetable(TVerlauf, filename, 'Sheet', 1);
%     writetable(TLaenge, filename, 'Sheet', 2);

     FilterSpec = '*.xlsx';
    [FileName,PathName,FilterIndex] = uiputfile(FilterSpec,'Vogt -> Excel');
    filename_Verlauf = [PathName, [FileName(1:end-4), '_Verlauf', FileName(end-4:end)]];
    filename_Laenge = [PathName, [FileName(1:end-4), '_Laenge', FileName(end-4:end)]];

    Zeit_Original = Zeit(lctg);
    
%     TVerlauf = table(Stunden, Minuten, Stunden,  Zeit_Original, Verlauf_y);
%     writetable(TVerlauf, filename_Verlauf, 'Delimiter', ';');
%     Stunden  = t_Laenge(:,1);
%     Minuten  = t_Laenge(:,2);
%     Sekunden = t_Laenge(:,3);
%     Zeit_Original = Zeit(ind_l);
%     TLaenge = table(Stunden, Minuten, Sekunden,  Zeit_Original, Laenge_y);
%     writetable(TLaenge, filename_Laenge, 'Delimiter', ';');

%    cw = {Stunden, Minuten, Sekunden, Verlauf_y, Zeit_Original};
    
    
    Stunden  = t_Laenge(:,1);
    Minuten  = t_Laenge(:,2);
    Sekunden = t_Laenge(:,3);
    t1 = t_Laenge*f';
    t1 = t1 - min(t1);
    t2 = t_Verlauf*f';
    t2 = t2 - min(t2);
    
    dw = [{'Stunden', 'Minuten', 'Sekunden', 'Länge','Sekunden seit Start'};num2cell(Stunden), num2cell(Minuten), num2cell(Sekunden), num2cell(Laenge_y), num2cell(t1)];
    
    Stunden  = t_Verlauf(:,1);
    Minuten  = t_Verlauf(:,2);
    Sekunden = t_Verlauf(:,3);
    
    cw = [{'Stunden', 'Minuten', 'Sekunden', 'Verlauf', 'Sekunden seit Start'};num2cell(Stunden), num2cell(Minuten), num2cell(Sekunden), num2cell(Verlauf_y), num2cell(t2)];
    xlswrite([PathName, FileName],dw, 1);
    xlswrite([PathName, FileName],cw, 2);
    
    written = true;
end




