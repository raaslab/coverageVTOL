% makingSTWv_Adj
% this function will create all s, t, weights, and v_Adj based off of the disntace and not have an
% edge to every battery level
% INPUTS
% area = is one dimension of the total area where the points are made (row
% x col = total area, it is row)
% x = the original points
% y = the original points that correspond to x
% numPoints = the amount of original points
% numLevels = the amount of levels
% v_Adj = this is the adjacency matrix that gives the costs
% OUTPUTS


function [sNew, tNew, weights, v_AdjNew, allDistances] =  makingSTWv_AdjF(maxDistance, x, y, numPoints, numLevels, v_Cluster, groupedPoints,turnRadius)
% maxDistance = sqrt((area(1)-area(2))^2+(area(3)-area(4))^2);
maxDistancePerLevel = maxDistance/numLevels;
tempLevelArray = [];
for i = 1:numLevels
    tempLevelArray(end+1) = i;
end
xShape = reshape(x, [],2);
yShape = reshape(y, [],2);
allDistances = [];
for i = 1:numPoints
    for j = 1:numPoints
        [row1,col1] = ind2sub(size(xShape),i);
        row2 = row1;
        if col1 == 1
            col2 = 2;
        elseif col1 == 2
            col2 = 1;
        else
            fprintf('error')
        end
        p1x1 = x(i);
        p1y1 = y(i);
        p1x2 = xShape(row2,col2);
        p1y2 = yShape(row2,col2);
        [row1,col1] = ind2sub(size(xShape),j);
        row2 = row1;
        if col1 == 1
            col2 = 2;
        elseif col1 == 2
            col2 = 1;
        else
            fprintf('error')
        end
        p2x1 = x(j);
        p2y1 = y(j);
        p2x2 = xShape(row2,col2);
        p2y2 = yShape(row2,col2);
        p1 = [x(i),y(i),atan2(p1y1-p1y2,p1x1-p1x2)];
        p2 = [x(j),y(j),atan2(p2y2-p2y1,p2x2-p2x1)];
        dubinsOut = dubins_core(p1,p2,turnRadius);
        allDistances(i,j) = sum(dubinsOut.seg_param)*dubinsOut.r;
    end
end
allDistancesRounded = ceil(allDistances./maxDistancePerLevel);
% outputv_Adj = v_Adj;
totalPoints = numPoints * numLevels;
tempv_AdjFinal = Inf(totalPoints);
tempv_Adj(1:totalPoints, 1:numPoints) = 0;
for i = 1:numPoints
    fillArray = allDistancesRounded(i, :);
    for j = 1:numLevels
        tempv_Adj((i-1)*numLevels+j, 1:numPoints) = fillArray;
    end
end
for i = 1:numPoints
    fillArray = tempv_Adj(:, i);
    for j = 1:numLevels
        tempv_AdjFinal(1:totalPoints, (i-1)*numLevels+j) = fillArray;
    end
end
% pointA = [];
% pointB = [];
sNew = [];
tNew = [];
weights = [];
matGroupedPoints = cell2mat(groupedPoints);
for i = 1:numPoints
    %     pointA = find(matGroupedPoints == i);
    for j = 1:numPoints
        node = find(matGroupedPoints == i, 1);
        numOfIterations = allDistancesRounded(i, j);
        % pointB = find(v_Cluster == j);
        weightIJ = allDistances(i, j);
        for k = 1:(numLevels-numOfIterations)
            if numOfIterations == 0 || i == j % you don't need both conditions because they do the same thing, but it helps me remember how things work
                break;
            end
            pointB = find(matGroupedPoints == j);
            sNew(end+1) = node;
            pointB = circshift(pointB, -(numOfIterations+k-1));
            tNew(end+1) = pointB(1);
            node = node+1;
            weights(end+1) = weightIJ;
        end
    end
end
numOfEdges = numel(sNew);
v_AdjNew = zeros(totalPoints);
for i = 1:numOfEdges
    v_AdjNew(sNew(i), tNew(i)) = weights(i);
end
end