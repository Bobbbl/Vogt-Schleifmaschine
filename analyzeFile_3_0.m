global valueb1
global valueb2
global Amplitude_DDeleted
global Amplitude_Deleted

valueb1 = 0;
valueb2 = 0;

%% Load File
filterSpec = '*.txt';
[fileName, pathName, fillterIndex] = uigetfile(filterSpec, 'Wähle dein File aus');
pathToFile = [pathName, fileName];
[Zeit,Amplitude] = importfile_1_1(pathToFile);

%% Plot Data
plot(Amplitude, 'o');
ax = gca;
%% Plot Line
x = get(gca, 'xlim');
[~,y] = ginput(1);
y = [y, y];
line(x,y);
%% Delete Points under Line
[row, col] = find(Amplitude <= y(1));
Amplitude_Deleted = Amplitude;
Amplitude_Deleted(row) = [];
%% Plot New Plots
plot(ax, Amplitude_Deleted, 'o');
%% Rufe Längendaten ab
[x, y] = ginput(1);
[row, col] = find(Amplitude_Deleted <= y);
Amplitude_DDeleted = Amplitude_Deleted;
Amplitude_DDeleted(row) = [];
%% Speichere die Verlaufsdaten
Verlauf_y = Amplitude_DDeleted;
%% Speichere die Laengendaten
%% Mache Filter Fenster
close all;
f = figure;
ax = axes('Parent', f, 'position', [0.1 0.6 0.8 0.38]);
l1 = uicontrol('Parent', f, 'Style', 'Text', 'Position', [100, 230, 100, 10], 'String', 'Threshold');
b1 = uicontrol('Parent', f, 'Style', 'slider', 'Position', [30,200,500,23]);
l2 = uicontrol('Parent', f, 'Style', 'Text', 'Position', [100, 180, 100, 10], 'String', 'Minimal Distance');
b2 = uicontrol('Parent', f, 'Style', 'slider', 'Position', [30,180-23-5,500,23]);
bbutter = uicontrol('Parent', f, 'Position', [30, 120, 500, 23], 'String', 'Butterworth Filter', 'Style', 'Text');

% Plotte die Originaldaten
plot(ax, Amplitude_Deleted, '.');

% Setze die Maxima und die Minima der Slider
set(b1, 'Min', 0);
ymax = get(ax, 'ylim');
ym = abs(ymax(2));
ymin = ymax(1);
valueb2 = ymin;

set(b1, 'Max', 1e-1);

set(b2, 'Min', ymin);
set(b2, 'Max', 0);

% Setze die Callbacks
set(b1, 'Callback', @CallbackB1);
set(b2, 'Callback', @CallbackB2);


hold on;
plot(ax, locs, pks, 'o', 'color', 'red');
hold off;


