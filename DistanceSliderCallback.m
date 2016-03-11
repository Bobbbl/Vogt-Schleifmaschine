function [ output_args ] = DistanceSliderCallback( src,evt )
	global f
	global butterValue
	global Amplitude_DDeleted

	butterValue = get(src, 'Value');

	[b, a] = butter(2, butterValue, 'low');
	Amplitude_Filter = filter(b,a,Amplitude_DDeleted);

	plot(Amplitude_DDeleted);
	hold on;
	plot(Amplitude_Filter, 'o');
	hold off;


