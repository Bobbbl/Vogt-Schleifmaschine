function [ output_args ] = ButtonCallback( src,evt )    
    global f
    global ax
    global lctg
    global pktg
    global Amplitude_DDeleted
    
    
    dataobjs = get(ax, 'Children');
    

    
   
    xdata = get(dataobjs, 'XData');
    lllskdflkds = get(get(gca, 'Children'), 'YData');
    
    lctg = xdata;
    Amplitude_DDeleted = dataobjs.YData;
    
    
    
    close(f);
    
    disp('OK');


end

