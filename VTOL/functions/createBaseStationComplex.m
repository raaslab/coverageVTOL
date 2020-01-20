% createBaseStationComplex.m
% This adds the base station, but gives costs to go to the base station,
% but not to come from the base station.

function [v_Adj,v_Type] = createBaseStationComplex(v_Adj,numPoints,numLevels,v_Cluster,groupedPoints,x,y,maxDistance,v_Type,v_ClusterLevels)

numInV_Adj = numel(v_Adj);
for i = 1:numInV_Adj
    if v_Adj(i) == 0
        v_Adj(i) = -1;
    end
end

x(end+1) = 0;
y(end+1) = 0;

depotID = (numPoints*numLevels)+1;
groupedPoints = cell2mat(groupedPoints);
v_Cluster = cell2mat(v_Cluster);

for i = 1:(numPoints*numLevels)
    id1 = groupedPoints(i);
    id2 = find((groupedPoints ~= groupedPoints(i)) & (v_Cluster == v_Cluster(i)),1,'last')/numLevels;
    
    if pdist([x(id1),y(id1);x(id2),y(id2)], 'euclidean')/(maxDistance/numLevels) <= v_ClusterLevels(i)
        v_Adj(i,depotID) = pdist([x(id1),y(id1);x(id2),y(id2)], 'euclidean');
    else
        v_Adj(i,depotID) = Inf;
    end
    v_Type(i,depotID) = 1;
end

% adds last row for depot to any site
totalPoints = numPoints*numLevels;
tempCostArray = [];
for i = 1:totalPoints
    if mod(i, numLevels) == 1
        tempCostArray(end+1) = 0;
    else
        tempCostArray(end+1) = -1;
    end
end
tempCostArray(end+1) = -1;
v_Adj(end+1, :) = tempCostArray';

end

