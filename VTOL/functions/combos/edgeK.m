% FF

function [outputEdges] = edgeK(v_Cluster,distances,levels,sites,clusterLevels,maxDistance,groupedPoints,fixedRatio)
maxDistanceF = maxDistance * fixedRatio;
uniqueClusters = max(unique(v_Cluster));
edges = zeros(sites);
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
                edges(point1, j) = costTemp + distances(point2, j);
            end
        end
    else
        tempFind = i;
        sameCluster = find(v_Cluster == tempFind);
        point2 = sameCluster(levels)/levels;
        point1 = sameCluster(end)/levels;
        costTemp = distances(point2, point1);
        for j = 1:sites
            if point1 == j || point2 == j
                edges(point2, j) = Inf;
            else
                edges(point2, j) = costTemp + distances(point1, j);
            end
        end
    end
end
maxDistancePerLevelF = maxDistanceF/levels;
outputEdges = zeros(sites*levels);
groupedPoints = cell2mat(groupedPoints);
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        if v_Cluster(i) == v_Cluster(j)
            outputEdges(i,j) = Inf;
        elseif edges(groupedPoints(i),groupedPoints(j)) > maxDistanceF
            outputEdges(i,j) = Inf;
        else
            numOfLevelsNeeded = ceil(edges(groupedPoints(i),groupedPoints(j))/maxDistancePerLevelF);
            if clusterLevels(i) - clusterLevels(j) == numOfLevelsNeeded
                outputEdges(i,j) = edges(groupedPoints(i),groupedPoints(j));
            else
                outputEdges(i,j) = Inf;
            end
        end
    end
end
end
