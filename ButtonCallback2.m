function [ output_args ] = ButtonCallback2( src,evt )  
global f
global ax
global Amplitude_DDeleted
global locs_DDeleted

dataobjs = get(ax, 'Children');

Amplitude_DDeleted = get(dataobjs, 'YData');
[row, col] = find(isnan(Amplitude_DDeleted));
Amplitude_DDeleted(col) = [];

xdata = get(dataobjs, 'XData');



close (f);