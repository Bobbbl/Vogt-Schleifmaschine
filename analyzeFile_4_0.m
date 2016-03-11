global goOn
global Amplitude
global lctg
global pktg
global f
global butterValue
global Amplitude_DDeleted
global ax
global locs_DDeleted

Amplitude_DDeleted = [];

goOn = true;
%% load File
filterSpec = '*.txt';
[fileName, pathName, fillterIndex] = uigetfile(filterSpec, 'Wähle dein File aus');
pathToFile = [pathName, fileName];
[Nummerierung,Zeit,Amplitude] = importfile_1_2(pathToFile);

%% Plot Data
f = figure('Hittest','off');
plot(Amplitude, '.');
oldLine = [];
set(f, 'KeyPressFcn', @GoOnCallback);
[~,y] = ginput(1);
y = [y,y];
    xlim = get(gca, 'xlim');
    x(1) = xlim(1);
    x(2) = xlim(2);
    oldLine = line(x,y);
    
while true
    
       button = questdlg('Fertig Christian?', 'OK');

    switch button
        case 'Yes'
            break;
        case 'No'
            valt = true;
        otherwise
            valt = false;
    end
    
    [~,y] = ginput(1);
    delete(oldLine);
    y = [y,y]; 
    oldLine = line(x,y);


    
    
end

[pks, locs] = findpeaks(Amplitude, 'MinPeakHeight', y(1));

close all;

plot(Amplitude);
hold on;
plot(locs, Amplitude(locs), 'o');
hold off;

%% Löse die Längendaten aus
Laenge_y = pks;
Laenge_x = locs;

%% Lösche die Längendaten aus dem Amplitudenvektor
Amplitude_Deleted = Amplitude;
Amplitude_Deleted(locs) = [];

%% Lösche die Null-Daten
close all;
f = figure;
ax = axes('Parent', f, 'position', [0.13 0.39  0.77 0.54]);
b = uicontrol('Parent', f, 'Style', 'pushbutton', 'Position', [81,30,419,23], 'String', 'OK');
set(b, 'Callback', @ButtonCallback2);

plot(Amplitude_Deleted);
h = brush;
set(h, 'Enable', 'on');

% Amplitude_DDeleted = pktg;
waitfor(f);

%Erzeuge Filter-GUI
% close all;
% f = figure;
% ax = axes('Parent', f, 'position', [0.13 0.39  0.77 0.54]);
% b = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
%               'value',0, 'min',0, 'max',1, 'SliderStep', [0.001 0.01]);
% set(b, 'Callback', @ButterSliderCallback);
% plot(Amplitude_DDeleted);
% waitfor(f);

% plot(Amplitude_Deleted);
% [x,y] = ginput;


% plot(Amplitude_DDeleted);
% [x,y] = ginput(2);

% y = ax + c
% a = (y(2) - y(1)) / (x(2) - x(1));
% c = y(1)-(a * x(1));
% x = 1:length(Amplitude_DDeleted);
% y = a.*x + c;
% idx = rangesearch([[1:length(Amplitude_DDeleted)]',Amplitude_DDeleted'],[x',y'], 100);

%% Besorge Polygon-Daten
valt = true;

while valt == true

	f = figure;
	plot(Amplitude_DDeleted);
	vvalt = true;
	while vvalt == true
		[xv, yv] = ginput;
		% Ersten Punkt als letzten Punkt setzen
		xv(end+1) = xv(1);
		yv(end+1) = yv(1);
		% Linie zeichnen
		l = line(xv,yv,'Color','b','LineWidth',1,'LineStyle','-');
		% Kurz dem User Zeit geben, um sein Werk zu bewundern
		pause(0.5);
		% Fragen ob die Auswahl passt
		button = questdlg('Passt das so?', 'OK');

		switch button
			case 'Yes'
				vvalt = false;
			case 'No'
				vvalt = true;
				delete(l);
			otherwise
				vvalt = false;
				delete(l);
		end
	end
	% Altes Fenster schliesen
	close(f);
	% Markierte Daten holen

	% Daten zum Suchen aufbereiten
	xq = 1:length(Amplitude_DDeleted);
	yq = Amplitude_DDeleted;

	% Punkte im Polygon suchen
	[in, on] = inpolygon(xq, yq, xv, yv);

	% Punkte plotten die im Polygon liegen
	f = figure;
	hold on
	plot(xq(in), yq(in), 'r+');
	plot(xq(~in), yq(~in), 'bo');
	% Fragen ob der ganze Vorgang wiederholt werden soll oder ob das
	% so passt
	button = questdlg('Passt das so?', 'OK');
	switch button
			case 'Yes'
				valt = false;
			case 'No'
				valt = true;
			otherwise
				valt = false;
		end
	close(f);
	
end
%% Zeit auswerten
f = [3600, 60, 1];
r = datevec(Zeit);
r = r(:, 4:6);
Verlauf_y = yq(in)';

t_Verlauf = r(in,:);
t_Laenge = r(locs, :);


%% Excel Datei schreiben
written = false;
if isunix && ~written
	
elseif ismac && ~written
	
else
	FilterSpec = '*.xlsx';
	[FileName,PathName,FilterIndex] = uiputfile(FilterSpec,'Vogt -> Excel');
	filename_Verlauf = [PathName, [FileName(1:end-4), '_Verlauf', FileName(end-4:end)]];
	filename_Laenge = [PathName, [FileName(1:end-4), '_Laenge', FileName(end-4:end)]];

	Stunden  = t_Laenge(:,1);
    Minuten  = t_Laenge(:,2);
    Sekunden = t_Laenge(:,3);
    t1 = t_Laenge*f';
    t1 = t1 - min(t1);
    t2 = t_Verlauf*f';
    t2 = t2 - min(t2);

    dw = [{'Stunden', 'Minuten', 'Sekunden', 'Sekunden seit Start', 'L�nge'};num2cell(Stunden), num2cell(Minuten), num2cell(Sekunden), num2cell(t1), num2cell(Laenge_y)];

    Stunden  = t_Verlauf(:,1);
    Minuten  = t_Verlauf(:,2);
    Sekunden = t_Verlauf(:,3);
    
    cw = [{'Stunden', 'Minuten', 'Sekunden', 'Sekunden seit Start','Verlauf'};num2cell(Stunden), num2cell(Minuten), num2cell(Sekunden), num2cell(t2), num2cell(Verlauf_y)];
    xlswrite([PathName, FileName],dw, 1);
    xlswrite([PathName, FileName],cw, 2);
    
    written = true;
end

msgbox('Datei geschrieben...');
