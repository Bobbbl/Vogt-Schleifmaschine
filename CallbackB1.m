function [outputargs] = CallbackB1(src, evt)
	
	global valueb1
	global valueb2
	global Amplitude_DDeleted
    global Amplitude_Deleted

	ax = gca;

	valueb1 = get(src, 'Value');

	[pks, locs] = findpeaks(Amplitude_Deleted, 'MinPeakHeight', valueb2, 'Threshold', valueb1);
    
    hold off;
    plot(Amplitude_Deleted, '.', 'color', 'blue');
	hold on;
	plot(ax, locs, Amplitude_Deleted(locs), 'o', 'Color', 'red');
    hold off;


