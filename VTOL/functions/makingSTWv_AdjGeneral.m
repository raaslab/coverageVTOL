% making STWGeneral
% this function will make v_Adj with the minimum type of edge between two
% points. There are 3 types of edges that can be use, but are constrained
% by certain properties
% INPUTS
% UGVSpeed = the time to travel one unit for the UGV (has to be greater than equal to 1)
% OUTPUTS

function [v_AdjNew,v_Type,sNew,tNew,v_ClusterLevels] = makingSTWv_AdjGeneral(maxDistance, x, y, numPoints, numLevels, v_Cluster, timeTO, timeL, rechargeRate, UGVSpeed, groupedPoints,UGVCapable,fixedRatio,turnRadius)

v_ClusterLevels = Inf([1, numPoints*numLevels]);
counter = 1;
for i = 1:numPoints
    for j = numLevels:-1:1
        v_ClusterLevels(counter) = j;
        counter = counter+1;
    end
end
v_ClusterLevels = v_ClusterLevels';

v_UGVCapable = Inf([1, numPoints*numLevels]);
counter = 1;
for i = 1:numPoints
    for j = 1:numLevels
        v_UGVCapable(counter) = UGVCapable(i);
        counter = counter+1;
    end
end
v_UGVCapable = v_UGVCapable';

% create all types of edges
% creating flying edges (only UAV and bat' < bat)
% edge types: These edges are also internal of clusters
[M, allDistancesM] = flyingM(maxDistance, x, y, numPoints, numLevels, v_Cluster, v_ClusterLevels, groupedPoints); % fly multi-rotor
[F, allDistancesF] = flyingF(maxDistance, x, y, numPoints, numLevels, v_Cluster, v_ClusterLevels, groupedPoints,fixedRatio,turnRadius); % fly fixed-wing
[FDUM] = flyDownUpM(numPoints, numLevels, M, v_Cluster, timeTO, timeL, allDistancesM, v_ClusterLevels, rechargeRate, UGVSpeed, groupedPoints, maxDistance); % flyDownUp mutli-rotor
[FDUF] = flyDownUpF(numPoints, numLevels, F, v_Cluster, timeTO, timeL, allDistancesF, v_ClusterLevels, rechargeRate, UGVSpeed, groupedPoints, maxDistance); % flyDownUp fixed-wing
[DTU] = downTravelUp(numPoints, numLevels, M, v_Cluster, timeTO, timeL, allDistancesM, v_ClusterLevels, rechargeRate, UGVSpeed, groupedPoints); % downTravelUp

sizeOfv_Cluster = size(v_Cluster);
tempV_Cluster = cell2mat(v_Cluster);
for i = 1:sizeOfv_Cluster
    if i > sizeOfv_Cluster/2
        tempV_Cluster(i, 2) = 0;
    else
        tempV_Cluster(i, 2) = 1;
    end
end
v_Cluster = tempV_Cluster(:,1);

FDUMNew = checkUGVPossibility(FDUM,v_UGVCapable,1);
FDUFNew = checkUGVPossibility(FDUF,v_UGVCapable,1);
DTUNew = checkUGVPossibility(DTU,v_UGVCapable,2);

% edge type combos: These edges are only external edges and the combination of the above edges
Aedge = edgeA(v_Cluster, allDistancesM, numLevels, numPoints, v_ClusterLevels, maxDistance, groupedPoints); % MMM
Cedge = edgeC(M, DTUNew, v_Cluster, allDistancesM, numLevels, numPoints, groupedPoints); % MGM
Eedge = edgeE(v_Cluster, allDistancesM, numLevels, numPoints, v_ClusterLevels, maxDistance, groupedPoints, allDistancesF,fixedRatio); % MFM
Gedge = edgeG(v_Cluster, allDistancesM, numLevels, numPoints, v_ClusterLevels, maxDistance, groupedPoints, allDistancesF,fixedRatio); % FMM
Iedge = edgeI(F, DTUNew, v_Cluster, allDistancesF, numLevels, numPoints, groupedPoints); % FGM
Kedge = edgeK(v_Cluster, allDistancesF, numLevels, numPoints, v_ClusterLevels, maxDistance, groupedPoints,fixedRatio); % FFM
Medge = edgeM(M,FDUMNew,v_Cluster,allDistancesM,numLevels,numPoints,groupedPoints,Aedge); % MMDU
Nedge = edgeN(M,FDUMNew,v_Cluster,numLevels,numPoints,groupedPoints); % MDUM
Oedge = edgeO(FDUMNew,v_Cluster,numLevels,numPoints,groupedPoints); % MDUMDU
Pedge = edgeP(F,FDUFNew,v_Cluster,allDistancesF, numLevels,numPoints,groupedPoints,Kedge); % FFDU
Qedge = edgeQ(F,FDUFNew,v_Cluster,numLevels,numPoints,groupedPoints); % FDUF
Redge = edgeR(FDUFNew,v_Cluster,numLevels,numPoints,groupedPoints); % FDUFDU
Sedge = edgeS(F,FDUMNew,v_Cluster,numLevels,numPoints,groupedPoints); % MDUF
Tedge = edgeT(M,FDUFNew,v_Cluster,allDistancesM,numLevels,numPoints,groupedPoints,Aedge); % MFDU
Uedge = edgeU(FDUFNew,v_Cluster,numLevels,numPoints,groupedPoints,FDUMNew); % MDUFDU
Vedge = edgeV(M,FDUFNew,v_Cluster,numLevels,numPoints,groupedPoints); % FDUM
Wedge = edgeW(F,FDUMNew,v_Cluster,allDistancesF,numLevels,numPoints,groupedPoints,Aedge); % FMDU
Xedge = edgeX(FDUMNew,v_Cluster,numLevels,numPoints,groupedPoints,FDUFNew); % FDUMDU

% pick the minimum cost edge here
numOfTotalPoints = numPoints * numLevels;
numberOfEdges = numel(Aedge);
v_AdjNew(1:numOfTotalPoints, 1:numOfTotalPoints) = Inf;
v_Type(1:numOfTotalPoints, 1:numOfTotalPoints) = 0;

for i = 1:numberOfEdges
    compare = [Aedge(i),Cedge(i),Eedge(i),Gedge(i),Iedge(i),Kedge(i),Medge(i),Nedge(i),Oedge(i),Pedge(i),Qedge(i),Redge(i),Sedge(i),Tedge(i),Uedge(i),Vedge(i),Wedge(i),Xedge(i)]; % array of all types of edge
    [v_AdjNew(i), v_Type(i)]= min(compare);
end

for i = 1:numberOfEdges
    if v_AdjNew(i) == Inf
        v_AdjNew(i) = 0;
        v_Type(i) = 0;
    end
end

sNew = [];
tNew = [];
weights = [];
for i = 1:numOfTotalPoints
    for j = 1:numOfTotalPoints
        if v_AdjNew(i, j) ~= 0
            sNew(end+1) = i;
            tNew(end+1) = j;
            weights(end+1) = v_AdjNew(i, j);
        end
    end
end
end
