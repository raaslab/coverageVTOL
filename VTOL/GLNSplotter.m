
% GLNSplotter.m
% plots the output from the GLNS solver. This file requires the output from
% GLNS in "GLNSSolution" and the two files rando1.mat and rando3.mat.

clear
close all
load /home/user01/Kevin_Yu/3D_bridge_meshes/coverageVTOL/VTOL/outputs/qualitativeExamples/journalQb1.mat
load /home/user01/Kevin_Yu/3D_bridge_meshes/coverageVTOL/VTOL/outputs/qualitativeExamples/journalQb3.mat

GLNSSolution = [281, 22, 323, 64, 365, 106, 127, 428, 169, 470, 211, 273, 535, 237, 561] % qualitative b (only multi-rotor flight)
% GLNSSolution = [281, 23, 325, 67, 369, 111, 135, 438, 163, 466, 209, 276, 532, 237, 561] % qualitative c (only multi-rotor with down up edges)
% GLNSSolution = [281, 23, 325, 67, 369, 111, 122, 425, 168, 471, 481, 267, 532, 237, 561] % qualitative d (UGV travel edges)
% GLNSSolution = [501, 242, 543, 465, 146, 487, 168, 409, 390, 71, 312, 93, 334, 15, 561] % qualitative e (only fixed-wing flight)
% GLNSSolution = [521, 228, 541, 210, 475, 441, 146, 411, 398, 82, 346, 50, 314, 18, 561] % qualitative f (mix of all types of edges)
% GLNSSolution = [501, 248, 541, 491, 196, 441, 146, 411, 397, 81, 286, 30, 334, 78, 561] % qualitative g (with down up edges)
% GLNSSolution = [43, 1401, 1251, 608, 1365, 1226, 481, 1136, 391, 1017, 973, 227, 881, 135, 789] % qualitative h (fixed-wing with down up edges)

totalCost = 0;
for i = 1:length(GLNSSolution)-1
    totalCost = totalCost + roundedGtspMatrix(GLNSSolution(i),GLNSSolution(i+1));
end
totalCost

v_Cluster = cell2mat(v_Cluster);
while GLNSSolution(1) ~= (numPointsInit * numBatteryLevels)+1
    GLNSSolution = circshift(GLNSSolution, 1);
end
GLNSSolution(end+1) = GLNSSolution(1);
GLNSSolutionOriginalPoints = ceil(GLNSSolution./numBatteryLevels);

orig_V_Cluster = zeros([numPointsInit, 1]);
for i = 1:numPointsInit
    orig_V_Cluster(i) = v_Cluster(i*numBatteryLevels);
end

GLNSSolutionWithAllPoints = GLNSSolutionOriginalPoints;
counter = 1;
for i = 1:length(GLNSSolutionOriginalPoints)
    if GLNSSolutionOriginalPoints(i) > numPointsInit
        counter = counter+1;
    else
        clusterToFind = orig_V_Cluster(GLNSSolutionOriginalPoints(i));
        tempNewData = find(orig_V_Cluster == clusterToFind);
        if tempNewData(1) ~= GLNSSolutionOriginalPoints(i)
            GLNSSolutionWithAllPoints = [GLNSSolutionWithAllPoints(1:counter), tempNewData(1), GLNSSolutionWithAllPoints(counter+1:end)];
            counter = counter+2;
        else
            GLNSSolutionWithAllPoints = [GLNSSolutionWithAllPoints(1:counter), tempNewData(2), GLNSSolutionWithAllPoints(counter+1:end)];
            counter = counter+2;
        end
    end
end

GLNSx = zeros(1,numel(x1)/2);
GLNSy = zeros(1,numel(y1)/2);

for a = 1:(numPointsInit)+1
    if a == 1
        GLNSx;
    else
        GLNSx(a) = x1(a-1);
        GLNSy(a) = y1(a-1);
    end
end
GLNSx = circshift(GLNSx, -1);
GLNSy = circshift(GLNSy, -1);
GLNSg = digraph;
GLNSg = addnode(GLNSg, numPointsInit+1);

% figure(1)
% plot(GLNSx, GLNSy,'-')
% axis equal
% title('Initial Graph Without Edge Costs Edges are Euclidean Distance Between Points')

S2 = zeros(1,numel(GLNSx)-2);
T2 = S2;
for a = 2:numel(GLNSx)-1
    S2(a-1) = GLNSSolutionWithAllPoints(a);
    T2(a-1) = GLNSSolutionWithAllPoints(a+1);
end

GLNSg = addedge(GLNSg,S2,T2);

% SPLITTING EDGES FROM SOLUTION
[S3, S4, S5, S6, S7, S8, T3, T4, T5, T6, T7, T8, downUpPoints] = deal([]);
impossible = 0;
lastPoint = 0;
% LEGEND FOR EDGE TYPES BELOW:
% typeChecker:EDGE; 1:A; 2:C; 3:E; 4:G; 5:I; 6:K; 7:M; 8:N; 9:O; 10:P;
% 11:Q; 12:R; 13:S; 14:T; 15:U; 16:V; 17:W; 18:X
for a = 2:(numPointsInit/2)+1
    if a == (numPointsInit/2)+1
        lastPoint = 1;
        typeChecker = v_Type(GLNSSolution(a),GLNSSolution(a+1));
        locationStart = find(GLNSSolutionWithAllPoints == GLNSSolutionOriginalPoints(a));
        locationEnd = find(GLNSSolutionWithAllPoints == GLNSSolutionOriginalPoints(a+1),1,'last');
    else
        typeChecker = v_Type(GLNSSolution(a),GLNSSolution(a+1));
        locationStart = find(GLNSSolutionWithAllPoints == GLNSSolutionOriginalPoints(a));
        locationEnd = find(GLNSSolutionWithAllPoints == GLNSSolutionOriginalPoints(a+1));
    end
    if typeChecker == 1 || typeChecker == 7 || typeChecker == 8 || typeChecker == 9 % MM
        S3(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T3(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S3(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T3(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    elseif typeChecker == 2 % MG
        S4(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T4(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S4(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T4(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    elseif typeChecker == 3 || typeChecker == 13 || typeChecker == 14 || typeChecker == 15 % MF
        S5(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T5(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S5(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T5(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    elseif typeChecker == 4 || typeChecker == 16 || typeChecker == 17 || typeChecker == 18 % FM
        S6(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T6(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S6(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T6(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    elseif typeChecker == 5 % FG
        S7(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T7(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S7(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T7(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    elseif typeChecker == 6 || typeChecker == 10 || typeChecker == 11 || typeChecker == 12 % FF
        S8(end+1) = GLNSSolutionWithAllPoints(locationStart);
        T8(end+1) = GLNSSolutionWithAllPoints(locationEnd-1);
        if lastPoint == 0
            S8(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
            T8(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    else
        impossible = 1;
        disp('error')
        break
    end
    lastPoint = 0;
    if (typeChecker == 7 || typeChecker == 10 || typeChecker == 14 || typeChecker == 17) && lastPoint == 0 % _ _DU
        downUpPoints(end+1) = GLNSSolutionWithAllPoints(locationEnd);
    elseif typeChecker == 8 || typeChecker == 11 || typeChecker == 13 || typeChecker == 16 % _DU_
        downUpPoints(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
    elseif typeChecker == 9 || typeChecker == 12 || typeChecker == 15 || typeChecker == 18 % _DU_DU
        downUpPoints(end+1) = GLNSSolutionWithAllPoints(locationStart+1);
        if lastPoint == 0
            downUpPoints(end+1) = GLNSSolutionWithAllPoints(locationEnd);
        end
    end
end

% S8 = [];
% T8 = [];
% for i = 1:numel(GLNSx)
%     for j = i+1:numel(GLNSx)
%         S8(end+1) = i;
%         T8(end+1) = j;
%     end
% end

% CREATING THE PLOT
if impossible == 0
    % GLNSg = addedge(GLNSg,S8,T8);
    figure(2)
    GLNSPlot = plot(GLNSg,'XData',GLNSx,'YData',GLNSy, 'LineWidth',3, 'EdgeColor', [0,0,1]);
    GLNSPlot.EdgeAlpha = 1;
    
    %     GLNSPlot.NodeLabel = {};
    axis equal
    %     axis([200 900 50 800])
    groupedPoints = cell2mat(groupedPoints);
    
    %     for i = 2:length(GLNSSolution)-1
    %         text(GLNSx(groupedPoints(GLNSSolution(i))), GLNSy(groupedPoints(GLNSSolution(i)))+0.1, num2str(v_ClusterLevels(GLNSSolution(i))), 'FontSize', 16)
    %     end
    hold on
    
    % highlight edges for UAV
    if isempty(S3) == 0                 %highlight type 1 edges: F-F
        highlight(GLNSPlot,S3, T3,'EdgeColor',[102,205,170]/255,'LineWidth',4, 'LineStyle', '-')
    end
    if isempty(S4) == 0                 %highlight type 2 edges: F-FDU
        highlight(GLNSPlot,S4, T4,'EdgeColor',[255,165,0]/255,'LineWidth',3, 'LineStyle', '-')
    end
    if isempty(S5) == 0                 %highlight type 3 edges: FDU-FDU
        highlight(GLNSPlot,S5, T5,'EdgeColor',[0,255,0]/255,'LineWidth',3, 'LineStyle', '-')
    end
    if isempty(S6) == 0                 %highlight type 4 edges: FDU-F
        highlight(GLNSPlot,S6, T6,'EdgeColor',[0,0,255]/255,'LineWidth',3, 'LineStyle', '-')
    end
    if isempty(S7) == 0                 %highlight type 4 edges: FDU-F
        highlight(GLNSPlot,S7, T7,'EdgeColor',[30,144,255]/255,'LineWidth',3, 'LineStyle', '-')
    end
    if isempty(S8) == 0                 %highlight type 4 edges: FDU-F
        highlight(GLNSPlot,S8, T8,'EdgeColor',[255,20,147]/255,'LineWidth',3, 'LineStyle', '-')
    end
    if isempty(downUpPoints) == 0
        highlight(GLNSPlot,downUpPoints,'MarkerSize',10)
        highlight(GLNSPlot,downUpPoints,'NodeColor',[0,0,0]/255)
    end
    
    
    % highlighting edges for UGV
    % highlight(GLNSPlot, S8, T8, 'EdgeColor', 'r', 'LineWidth', 4)
    
    %     highlight(GLNSPlot, S2)             %highlights nodes
    %     highlight(GLNSPlot, numel(S2))    %highlights last node
else
    disp('impossible input');
end

hold on
for i = 2:2:length(GLNSx)-1
    [cord,~,~] = createRectangle(GLNSx(GLNSSolutionWithAllPoints(i)), GLNSy(GLNSSolutionWithAllPoints(i)), GLNSx(GLNSSolutionWithAllPoints(i+1)), GLNSy(GLNSSolutionWithAllPoints(i+1)));
    plot(cord(:,1),cord(:,2), 'color', 'k', 'linewidth',2)
    
end

h = zeros(6, 1);
h(1) = plot(NaN,NaN,'color', [102,205,170]/255);
h(2) = plot(NaN,NaN,'color', [255,165,0]/255);
h(3) = plot(NaN,NaN,'color', [0,255,0]/255);
h(4) = plot(NaN,NaN,'color', [0,0,255]/255);
h(5) = plot(NaN,NaN,'color', [30,144,255]/255);
h(6) = plot(NaN,NaN,'color', [255,20,147]/255);
legg = legend(h,'MM','MG','MF','FM','FG','FF');
legg.FontSize = 9;
title('Output Tour', 'Fontsize', 16)
% set(gca,'Ydir','reverse')

% close all;
