% downUpFly
% this will make a v_Adj with UAV land, takeoff, fly on it
% INPUTS

% OUTPUTS

function [v_AdjNew, distances] = flyDownUpF(numPoints, numLevels, v_Adj, v_Cluster, timeTO, timeL, distances, v_ClusterLevels, rRate, UGVratio, groupedPoints, maxDistance)
% v_Cluster = cell2mat(v_Cluster);
totalPoints = numPoints * numLevels;
v_AdjTemp = v_Adj;
v_AdjNew = v_Adj*Inf;
groupedPoints = cell2mat(groupedPoints);
for i = 1:totalPoints
    for j = 1:numPoints
        if groupedPoints(i) ~= j
            if j == 2 && i == 8
                j;
            end
            pointA = i;
            pointB = find(groupedPoints == j);
            correctPointB = flipud(pointB);
            originalEdge = find(v_AdjTemp(pointA, pointB(1):pointB(end)) ~= Inf); % Not based on only fly, but possible to fly
            lowestLevel = v_ClusterLevels(pointB(originalEdge));
            if lowestLevel == numLevels
                for k = 1:numLevels
                    rechargeTime = rRate*(k-lowestLevel);
                    UAVTravelTime = distances(groupedPoints(i), j);
                    cost = UAVTravelTime + rechargeTime + timeTO + timeL;
                    v_AdjNew(i, correctPointB(k)) = cost;
                end
            elseif (distances(groupedPoints(i),j)/maxDistance > (v_ClusterLevels(i)-1)/numLevels) && (distances(groupedPoints(i),j)/maxDistance <= v_ClusterLevels(i)/numLevels) % something is wrong with how i find the difference between the values
                for k = 1:numLevels
                    rechargeTime = rRate*(k-0);
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
