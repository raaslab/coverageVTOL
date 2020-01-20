% FMM

function [outputEdges] = edgeG(v_Cluster,distances,levels,sites,clusterLevels,maxDistance,groupedPoints,distances2,fixedRatio)
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
        costTemp = distances2(point1, point2);
        for j = 1:sites
            if point1 == j || point2 == j
                edges(point1, j) = Inf;
            else
                edges(point1, j) = costTemp + distances(point2, j);
            end
        end
    else
        tempFind = i;
        sameCluster = find(v_Cluster == tempFind);
        point2 = sameCluster(levels)/levels;
        point1 = sameCluster(end)/levels;
        costTemp = distances2(point2, point1);
        for j = 1:sites
            if point1 == j || point2 == j
                edges(point2, j) = Inf;
            else
                edges(point2, j) = costTemp + distances(point1, j);
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
            costTemp = distances2(point1, point2);
            if v_Cluster(i) == v_Cluster(j)
                outputEdges(i,j) = Inf;
            elseif costTemp > maxDistanceF || distances(point2,tempJ) > maxDistance
                outputEdges(i,j) = Inf;
            else
                numOfLevelsNeededF = ceil(costTemp/maxDistancePerLevelF);
                numOfLevelsNeeded = ceil(distances(point2,tempJ)/maxDistancePerLevel);
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
            costTemp = distances2(point2, point1);
            if v_Cluster(i) == v_Cluster(j)
                outputEdges(i,j) = Inf;
            elseif costTemp > maxDistanceF || distances(point1,tempJ) > maxDistance
                outputEdges(i,j) = Inf;
            else
                numOfLevelsNeededF = ceil(costTemp/maxDistancePerLevelF);
                numOfLevelsNeeded = ceil(distances(point1,tempJ)/maxDistancePerLevel);
                totLevelsNeeded = numOfLevelsNeeded + numOfLevelsNeededF;
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
