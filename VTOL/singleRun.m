% specificRuns
% this will run a specific case for if there's an error within "time"
% variable
clc; clear all; close all;

% numBC = 20;
max_Distance = 1800;   % if max_Distance == j then discharge is unit rate per distance (budget)
j = 20;
tTO = 5;           % take off cost
tL = 45;            % landing cost
rRate = 2;         % rate of recharge
UGVS = 5;          % time to travel one unit for the UGV to multi-rotor (greater than 1 means UGV is slower)
method = 1;        % 1 = GLNS, 0 = concorde
timeI = [];
fixedRatio = 3;     % ratio of multi-rotor to fixed-wing battery usage per distance (1lvl/5m : 1lvl/10m = 2) (greater than 1 means fixed wing goes farther on one battery level)
turnRadius = 3;     % turn radius for dubins constraints in 

% changing number of input BC

% filename4 = sprintf('inputs/timeVSi/%d_%d.txt',trial,numBC);
% polygonCreater(filename4,numBC,100,0,0) % creates random polygons.

% TODO: check why the path from every node to the new last node is always type 1 edge?
% use 'testInput.txt' if you want the file from polygonCreater
data = readData('/home/user01/Kevin_Yu/coverageVTOL/VTOL/inputs/exampleBC/exampleFigureBC.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
[numClusters, ~] = size(data);
x = [data(:,1), data(:,4)];
y = [data(:,2), data(:,5)];
UGVCapable = [data(:,3), data(:,6)];

G = 0;

i = numClusters*2; % number of vertices needed to be multiplied by battery levels

filename1 = sprintf('journal1');
filename2 = sprintf('/home/user01/Kevin_Yu/coverageVTOL/VTOL/outputs/exampleBC/journal2.gtsp');
filename3 = sprintf('journal3');
pathName = '/home/user01/Kevin_Yu/coverageVTOL/VTOL/outputs/exampleBC';

tic
% pathName = '/home/klyu/lab/coverageWork/testForCoverage/errorInstance'; % for error instances
[ansTime,gtspMatrix,gtspTime, v_Cluster] = testGeneral(i, j, filename1, tTO, tL, rRate, UGVS, x, y, method, max_Distance, pathName,UGVCapable,fixedRatio,turnRadius);

% making GLNS matrix input
roundedGtspMatrix = round(gtspMatrix);
roundedGtspMatrix(roundedGtspMatrix == -1) = 999999;
roundedGtspMatrix(roundedGtspMatrix == Inf) = 999999;
createGTSPFile(filename2,roundedGtspMatrix, i, j, v_Cluster) % creating GLNS file
f = fullfile(pathName, filename3);
trialTime = toc
save(f);

% Run GLNS after this
% Run Plotter after this
