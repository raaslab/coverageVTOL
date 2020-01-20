% MFM

function [outputEdges] = edgeE(v_Cluster, distances, levels, sites, clusterLevels, maxDistance, groupedPoints, distances2,fixedRatio)
uniqueClusters = max(unique(v_Cluster));
edges = zeros(sites);
maxDistanceF = maxDistance * fixedRatio;
maxDistancePerLevelF = maxDistanceF/levels;
maxDistancePerLevel = maxDistance/levels;
outputEdges = zeros(sites*levels);
groupedPoints = cell2mat(groupedPoints);
for i = 1:sites
    if i > uniqueClusters
        tempFind = (i - uniqueClusters);
        sameCluster = find(v_Cluster == tempFind);
        point2 = sameCluster(levels)/levels;
        point1 = sameCluster(end)/levels;
        costTemp = distances(point1, point2);
        for j = 1:sites
            if point1 == j || point2 == j
                edges(point1, j) = Inf;
            else
                edges(point1, j) = costTemp + distances2(point2, j);
            end
        end
    else
        tempFind = i;
        sameCluster = find(v_Cluster == tempFind);
        point2 = sameCluster(levels)/levels;
        point1 = sameCluster(end)/levels;
        costTemp = distances(point1, point2);
        for j = 1:sites
            if point1 == j || point2 == j
                edges(point2, j) = Inf;
            else
                edges(point2, j) = costTemp + distances2(point1, j);
            end
        end
    end
end
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        tempI = ceil(i/levels);
        tempJ = ceil(j/levels);
        if tempI > uniqueClusters
            tempFind = (tempI - uniqueClusters);
            sameCluster = find(v_Cluster == tempFind);
            point2 = sameCluster(levels)/levels;
            point1 = sameCluster(end)/levels;
            costTemp = distances(point1, point2);
            if v_Cluster(i) == v_Cluster(j)
                outputEdges(i,j) = Inf;
            elseif costTemp > maxDistance || distances2(point2,tempJ) > maxDistanceF
                outputEdges(i,j) = Inf;
            else
                numOfLevelsNeeded = ceil(costTemp/maxDistancePerLevel);
                numOfLevelsNeededF = ceil(distances2(point2,tempJ)/maxDistancePerLevelF);
                totLevelsNeeded = numOfLevelsNeeded + numOfLevelsNeededF;
                if clusterLevels(i) - clusterLevels(j) == totLevelsNeeded
                    outputEdges(i,j) = edges(groupedPoints(i),groupedPoints(j));
                else
                    outputEdges(i,j) = Inf;
                end
            end
        else
            tempFind = tempI;
            sameCluster = find(v_Cluster == tempFind);
            point2 = sameCluster(levels)/levels;
            point1 = sameCluster(end)/levels;
            costTemp = distances(point1, point2);
            if v_Cluster(i) == v_Cluster(j)
                outputEdges(i,j) = Inf;
            elseif costTemp > maxDistance || distances2(point1,tempJ) > maxDistanceF
                outputEdges(i,j) = Inf;
            else
                numOfLevelsNeeded = ceil(costTemp/maxDistancePerLevel);
                numOfLevelsNeededF = ceil(distances2(point1,tempJ)/maxDistancePerLevelF);
                totLevelsNeeded = numOfLevelsNeeded+numOfLevelsNeededF;
                if clusterLevels(i) - clusterLevels(j) == totLevelsNeeded
                    outputEdges(i,j) = edges(groupedPoints(i),groupedPoints(j));
                else
                    outputEdges(i,j) = Inf;
                end
            end
        end
    end
end
end
