% downUpFly
% this will make a v_Adj with UAV land, takeoff, fly on it
% THIS IS OBSOLETE!!!
% INPUTS

% OUTPUTS

function [v_AdjNew, distances] = downUpFly(numPoints, numLevels, v_Adj, v_Cluster, timeTO, timeL, distances, v_ClusterLevels, rRate, UGVratio, groupedPoints)

v_Cluster = cell2mat(v_Cluster);
totalPoints = numPoints * numLevels;
v_AdjNew(1:totalPoints, 1:totalPoints) = Inf;
groupedPoints = cell2mat(groupedPoints);

for i = 1:totalPoints
    for j = 1:numPoints
        if groupedPoints(i) ~= j
            pointA = i;
            pointB = find(groupedPoints == j);
            correctPointB = flipud(pointB);
            originalEdge = find(v_AdjNew(pointA, pointB(1):pointB(end)) ~= Inf);
            lowestLevel = v_ClusterLevels(pointB(originalEdge));
            if lowestLevel == numLevels
                for k = 1:numLevels
                    rechargeTime = rRate*(k-lowestLevel);
                    UAVTravelTime = distances(groupedPoints(i), j);
                    cost = UAVTravelTime + rechargeTime + timeTO + timeL;
                    v_AdjNew(i, correctPointB(k)) = cost;
                end
            else
                for k = lowestLevel+1:numLevels
                    rechargeTime = rRate*(k-lowestLevel);
                    UAVTravelTime = distances(groupedPoints(i), j);
                    cost = UAVTravelTime + rechargeTime + timeTO + timeL;
                    v_AdjNew(i, correctPointB(k)) = cost;
                end
            end
        end
    end
end

for i = 1:totalPoints
    for j = 1:totalPoints
        if groupedPoints(i) == groupedPoints(j)
            v_AdjNew(i, j) = Inf;
        end
    end
end


end
