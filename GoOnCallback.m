function [ output_args ] = GoOnCallback( src,evt )
	global goOn
    global Amplitude
    
%     plot(Amplitude, '.');
%     hold on;
%     xlim = get(gca, 'xlim');
%     x(1) = xlim(1);
%     x(2) = xlim(2);
%     
%     [~,y] = ginput(1);
%     y = [y,y]; 
%     line(x,y);
%     hold off;
    goOn = false;