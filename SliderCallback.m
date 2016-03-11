function [ output_args ] = SliderCallback( src,evt )
    global prom
    global f
    global ax
    global lctg
    global pktg
    global Amplitude_Kg

    global th
    
    th = get(src, 'Value');
    
    [pktg, lctg] = findpeaks(Amplitude_Kg,  'Threshold', th);
    plot(ax, lctg, pktg, 'x');
    disp(prom)

end

