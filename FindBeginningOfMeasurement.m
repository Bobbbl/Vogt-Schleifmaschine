function [ index ] = FindBeginningOfMeasurement( Amplitude )
firstVar = Amplitude(1);
nowVar = NaN;
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



end

