% testGeneral
% testing of program
% for my own work
% INPUTS
% UGVSpeed = the time to travel one unit for the UGV (has to be greater than equal to 1)
% method = 1 is GLNS, 0 is concorde
% OUTPUTS

function [time,gtspWeightMatrix2, gtspTime, v_Cluster] = testGeneral(numPointsInit, numBatteryLevels, filename, timeTO, timeL, rechargeRate, UGVSpeed, x, y, method, maxDistance, pathName,UGVCapable,fixedRatio,turnRadius)

time = 0;
rotation = 51; % value used for rotating in graphMakingNew, in degrees
nodeArray = [];

for i = 1:numPointsInit*numBatteryLevels
    nodeArray(end+1) = i;
end
nodeArray = nodeArray';
x1 = reshape(x, 1, []);
y1 = reshape(y, 1, []);
UGVCapable1 = reshape(UGVCapable, 1, []);
[T, x3d, y3d, z3d] = tableMaking(x1, y1, numBatteryLevels);

% creates 3D plots
figure('Visible','off');
h = scatter3(x3d, y3d, z3d);
% creates new graph with existing points
[G2, x2, y2] = graphMakingWPoints(h.XData, h.YData);
[v_Cluster] = makingV_cluster(numPointsInit, numBatteryLevels);
v_Cluster = num2cell(v_Cluster);

[groupedPoints] = makingGroupedPoints(numPointsInit, numBatteryLevels);
groupedPoints = num2cell(groupedPoints);

[v_Adj, v_Type, S1, T1, v_ClusterLevels] = makingSTWv_AdjGeneral(maxDistance, x1, y1, numPointsInit, numBatteryLevels, v_Cluster, timeTO, timeL, rechargeRate, UGVSpeed, groupedPoints,UGVCapable1,fixedRatio,turnRadius);

[xOut, yOut] = graphingCluster(x1, y1, numPointsInit, numBatteryLevels, S1, T1, 0, nodeArray, method); % graph in cluster format

% GTSP solver
% tic;
[finalMatrix,G_init,edgeWeightsFinal,finalTour,gtspWeightMatrix,gtspWeightMatrix2,v_Type] = gtspSolver(v_Cluster,v_Adj,numPointsInit,numBatteryLevels,method,groupedPoints,x1,y1,maxDistance,v_Type,v_ClusterLevels);
gtspTime = 0;

f = fullfile(pathName, filename);
save(f);

end

