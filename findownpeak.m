function [index] = findownpeak(array, vor, danach)

    index = NaN;
    a = [];
    b = [];
    c = [];

    for i=vor+1:length(array)-danach
        a = array(i-vor);
        b = array(i);
        c = array(i+danach);
        
        if ((a<b) && (c<b))
            index = i;
            break;
        end
    end