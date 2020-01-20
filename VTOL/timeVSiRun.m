% specificRuns
% this will run a specific case for if there's an error within "time"
% variable
dbstop error
clc; clear all; close all;

% numBC = 20;

max_Distance = 1000;   % if max_Distance == j then discharge is unit rate per distance (budget)
j = 20;
tTO = 100;           % take off cost
tL = 100;            % landing cost
rRate = 2;         % rate of recharge
UGVS = 5;          % time to travel one unit for the UGV (greater than 1 means UGV is slower)
method = 1;        % 1 = GLNS, 0 = con  corde
timeI = [];
fixedRatio = 3;
turnRadius = 1;
% changing number of input BC
loop = 0;
for trial  = 1:10
    for numBC = 10:1:50
        
        filename4 = sprintf('inputs/timeVSi/%d_%d.txt',trial,numBC);
        polygonCreater(filename4,numBC,100,0,0) % creates random polygons.
        
        % use 'testInput.txt' if you want the file from polygonCreater
        data = readData(filename4); % get the size and shape from the data (this will tell you number of clusters points and so on)
        [numClusters, ~] = size(data);
        x = [data(:,1), data(:,4)];
        y = [data(:,2), data(:,5)];
        UGVCapable = [data(:,3), data(:,6)];
        
        G = 0;
        i = numClusters*2; % number of vertices needed to be multiplied by battery levels
        
        
        filename1 = sprintf('%d_%d_1',trial,numBC);
        filename2 = sprintf('/home/user01/Kevin_Yu/3D_bridge_meshes/coverage/VTOL/outputs/timeVSi/%d_%d_2.gtsp', trial,numBC);
        filename3 = sprintf('%d_%d_3',trial,numBC);
        
        tic
        pathName = '/home/user01/Kevin_Yu/3D_bridge_meshes/coverage/VTOL/outputs/timeVSi';
        % pathName = '/home/klyu/lab/coverageWork/testForCoverage/errorInstance'; % for error instances
        [ansTime,gtspMatrix,gtspTime, v_Cluster] = testGeneral(i, j, filename1, tTO, tL, rRate, UGVS, x, y, method, max_Distance, pathName,UGVCapable,fixedRatio,turnRadius);
        
        % making GLNS matrix input
        roundedGtspMatrix = round(gtspMatrix);
        roundedGtspMatrix(roundedGtspMatrix == -1) = 999999;
        roundedGtspMatrix(roundedGtspMatrix == Inf) = 999999;
        createGTSPFile(filename2,roundedGtspMatrix, i, j, v_Cluster) % creating GLNS file
        f = fullfile(pathName, filename3);
        save(f);
        trialTime = toc
        timeI(end+1, :) = [trial, double(numBC), trialTime];
        fprintf("loop:%d\n",loop)
        loop = loop + 1;
    end
end

save('timeVSi.mat')
