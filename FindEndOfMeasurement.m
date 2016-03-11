function [ index ] = FindEndOfMeasurement( Amplitude )
len = length(Amplitude);
Amplitude = Amplitude(end:-1:1);
firstVar = Amplitude(1);
nowVar = [];
endVar = false;
index = 1;
while ~endVar
    nowVar = Amplitude(index);
    if abs(nowVar - firstVar) > 0.09
        endVar = true;
        continue;
    end
    index = index + 1;
    firstVar = nowVar;
end

index = index - 1;
index = len - index;


end

