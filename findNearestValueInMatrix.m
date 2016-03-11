function [closestvalue, row, col] = findNearestValueInMatrix(mapFindin, valFind)

tmp = abs(mapFindin - valFind);

[M, I] = min(tmp(:));

[row, col] = find(mapFindin==mapFindin(I));

closestvalue = M;