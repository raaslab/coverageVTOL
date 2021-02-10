% specificRuns
% this will run a specific case for if there's an error within "time"
% variable
clc; clear all; close all;
saveFile = 0;

% numBC = 20;
max_Distance = 1000;   % if max_Distance == j then discharge is unit rate per distance (budget)
j = 100;
tTO = 100;           % take off cost
tL = 100;            % landing cost
rRate = 2;         % rate of recharge
UGVS = 5;          % time to travel one unit for the UGV to multi-rotor (greater than 1 means UGV is slower)
method = 1;        % 1 = GLNS, 0 = concorde
timeI = [];
fixedRatio = 0.5;     % ratio of multi-rotor to fixed-wing battery usage per distance (1lvl/5m : 1lvl/10m = 2) (greater than 1 means fixed wing goes farther on one battery level)
turnRadius = 3;     % turn radius for dubins constraints in 

% changing number of input BC

% filename4 = sprintf('inputs/timeVSi/%d_%d.txt',trial,numBC);
% polygonCreater(filename4,numBC,100,0,0) % creates random polygons.

% TODO: check why the path from every node to the new last node is always type 1 edge?
% use 'testInput.txt' if you want the file from polygonCreater
data = readData('inputs/fieldExperiments/kentLand2.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
[numClusters, ~] = size(data);
x = [data(:,1), data(:,4)];
y = [data(:,2), data(:,5)];
UGVCapable = [data(:,3), data(:,6)];

G = 0;

i = numClusters*2; % number of vertices needed to be multiplied by battery levels

filename1 = sprintf('kentLand2_1');
filename2 = sprintf('/home/user01/Kevin_Yu/coverageVTOL/VTOL/outputs/fieldExperiments/kentLand2_2.gtsp');
filename3 = sprintf('kentLand2_3');
pathName = '/home/user01/Kevin_Yu/coverageVTOL/VTOL/outputs/fieldExperiments';

tic
% pathName = '/home/klyu/lab/coverageWork/testForCoverage/errorInstance'; % for error instances
[ansTime,gtspMatrix,gtspTime, v_Cluster] = testGeneral(i, j, filename1, tTO, tL, rRate, UGVS, x, y, method, max_Distance, pathName,UGVCapable,fixedRatio,turnRadius,saveFile);

% making GLNS matrix input
roundedGtspMatrix = round(gtspMatrix);
roundedGtspMatrix(roundedGtspMatrix == -1) = 999999;
roundedGtspMatrix(roundedGtspMatrix == Inf) = 999999;
if(saveFile == 1)
    createGTSPFile(filename2,roundedGtspMatrix, i, j, v_Cluster) % creating GLNS file
end
f = fullfile(pathName, filename3);
trialTime = toc
if(saveFile == 1)
    save(f);
end
% Run GLNS after this
% Run Plotter after this
