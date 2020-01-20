% maxDistance
% finds the maximum distance between all possible points

function [distance] = maxDistance(x, y)
[h1, w1] = size(x);

distance = 0;
for i = 1 : h1*w1
    for j = 1 : h1*w1
        testPoint  = [x(i), y(i); x(j), y(j)];
        distanceTemp = pdist(testPoint, 'euclidean');
        distance = max(distance, distanceTemp);
    end
end
end