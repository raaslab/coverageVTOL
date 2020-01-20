% specificRuns
% this will run a specific case for if there's an error within "time"
% variable

% FINISHED USE DON'T CHANGE FILE
% USE "specificRuns" IF YOU WANT TO DO MORE RUNS
% OR MAKE A COPY OF "specificRuns" AND USE THAT

dbstop error
clc; clear all; close all;

G = 0;
% x = 0;
% y = 0;
% j = 20;             % number of battery levels
tTO = 1000;           % take off cost
tL = 1000;            % landing cost
rRate = 2;         % rate of recharge
UGVS = 5;          % time to travel one unit for the UGV (greater than 1 means UGV is slower)
method = 1;        % 1 = GLNS, 0 = con  corde
numBC = 15;


timeUnit = [];

for trial = 1:1
    display(trial)
    filename4 = sprintf('inputs/costVSbudget%d.txt',trial);
    polygonCreaterSmall(filename4,numBC,100,0,0,10) % creates random polygons.
    data = readData(filename4); % get the size and shape from the data (this will tell you number of clusters points and so on)
    [numClusters, ~] = size(data);
    x = [data(:,1), data(:,4)];
    y = [data(:,2), data(:,5)];
    UGVCapable = [data(:,3), data(:,6)];
    for forLoopVariable = 10:50
        display(forLoopVariable)
        tic
        max_Distance = forLoopVariable;   % if max_Distance == j then discharge is unit rate per distance (budget)
        i = numClusters*2; % number of vertices needed to be multiplied by battery levels
        %     j = forLoopVariable;
        j = 20;
        filename1 = sprintf('/%d/1_%d',trial,forLoopVariable);
        filename2 = sprintf('/home/klyu/lab/coverageWork/testForCoverage/costVSbudget/%d/2_%d.gtsp', trial, forLoopVariable);
        filename3 = sprintf('/%d/3_%d',trial,forLoopVariable);
        
        pathName = '/home/klyu/lab/coverageWork/testForCoverage/costVSbudget/';
        [ansTime,gtspMatrix,gtspTime, v_Cluster] = testGeneral(i, j, filename1, tTO, tL, rRate, UGVS, G, x, y, method, max_Distance, pathName,UGVCapable);
        
        % making GLNS matrix input
        roundedGtspMatrix = round(gtspMatrix);
        roundedGtspMatrix(roundedGtspMatrix == -1) = 999999;
        roundedGtspMatrix(roundedGtspMatrix == Inf) = 999999;
        createGTSPFile(filename2,roundedGtspMatrix, i, j, v_Cluster) % creating GLNS file
        f = fullfile(pathName, filename3);
        save(f);
        trialTime = toc;
        timeUnit(end+1, :) = [double(forLoopVariable), trialTime];
    end
end

save('costVSbudget.mat')

