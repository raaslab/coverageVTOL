% createBaseStation
% creates the start and end point for the tour (the base station) with edge
% cost close to zero
% INPUTS
% v_Cluster = v_Cluster for GTSP solver without base station
% v_Adj = v_Adj for GTSP solver without base station
% alpha = allows for correct cost for base station
% beta = allows for correct cost for base station
% numPoints = number of nodes in a graph
% numLevels = number of battery levels in a graph
% OUTPUTS
% v_Cluster = v_Cluster for GTSP solver with base station
% v_Adj = v_Adj for GTSP solver with base station

function [v_Adj] = createBaseStationSimple(v_Adj, numPoints, numLevels)

numInV_Adj = numel(v_Adj);
for i = 1:numInV_Adj
    if v_Adj(i) == 0;
       v_Adj(i) = -1; 
    end
end

v_Adj(:, end+1) = 0;
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