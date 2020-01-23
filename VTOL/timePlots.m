% plots for ICRA 2019
% plots all of the time figures
dbstop error
clear all
close all
clc

% load timeData.mat
load timeVSi.mat
timeIall = timeI;
load timeVSj.mat
timeJall = timeJ;
load timeVSturnRadius.mat
timeVSturnRadiusall = timeTurnRadius;
load timeVSfixedRatio.mat
timeVSfixedRatioall = timeFixedRatio;

% plot for time vs sites
figure(2)
neg = [];
pos = [];
avgTimeVSsite = [];

for i = 10:1:50
    index = find(timeIall(:,2)==i);
    averageArray = Inf([1,length(index)]);
    for j = 1:length(index)
        averageArray(j) = timeIall(index(j),3);
    end
    averageTime = sum(averageArray)/length(averageArray);
    neg(end+1,:) = [i,abs(min(averageArray)-averageTime)];
    pos(end+1,:) = [i,abs(max(averageArray)-averageTime)];
    avgTimeVSsite(end+1,:) = [i,averageTime];
end
errorbar(avgTimeVSsite(:,1),avgTimeVSsite(:,2),neg(:,2), pos(:,2),'b-o','LineWidth', 2)
title('Computational Time vs. Boustrophedon Cells', 'FontSize', 16)
xlabel('Number of Input Boustrophedon Cells','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)

% plot for time vs battery levels
figure(3)
neg = [];
pos = [];
averageTimeVSlevel =[];

for i = 10:10:100
    index = find(timeJall(:,2)==i);
    averageArray = Inf([1,length(index)]);
    for j = 1:length(index)
        averageArray(j) = timeJall(index(j),3);
    end
    averageTime = sum(averageArray)/length(averageArray);
    neg(end+1,:) = [i,abs(min(averageArray)-averageTime)];
    pos(end+1,:) = [i, abs(max(averageArray)-averageTime)];
    averageTimeVSlevel(end+1,:) = [i,averageTime];
end
errorbar(averageTimeVSlevel(:,1), averageTimeVSlevel(:,2),neg(:,2),pos(:,2),'b-o','LineWidth', 2)
title('Computational Time vs. Battery Levels','FontSize', 16)
xlabel('Number of Battery Levels','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)

% plot for time vs turnRadius
figure(4)
neg = [];
pos = [];
averageTimeVSlevel =[];

for i = 1:1:10
    index = find(timeVSturnRadiusall(:,2)==i);
    averageArray = Inf([1,length(index)]);
    for j = 1:length(index)
        averageArray(j) = timeVSturnRadiusall(index(j),3);
    end
    averageTime = sum(averageArray)/length(averageArray);
    neg(end+1,:) = [i,abs(min(averageArray)-averageTime)];
    pos(end+1,:) = [i, abs(max(averageArray)-averageTime)];
    averageTimeVSlevel(end+1,:) = [i,averageTime];
end
errorbar(averageTimeVSlevel(:,1), averageTimeVSlevel(:,2),neg(:,2),pos(:,2),'b-o','LineWidth', 2)
title('Computational Time vs. Turn Radius','FontSize', 16)
xlabel('Turn Radius (meters)','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)

% plot for time vs fixedRatio
figure(5)
neg = [];
pos = [];
averageTimeVSlevel =[];

for i = 1:1:20
    index = find(timeVSfixedRatioall(:,2)==i);
    averageArray = Inf([1,length(index)]);
    for j = 1:length(index)
        averageArray(j) = timeVSfixedRatioall(index(j),3);
    end
    averageTime = sum(averageArray)/length(averageArray);
    neg(end+1,:) = [i,abs(min(averageArray)-averageTime)];
    pos(end+1,:) = [i, abs(max(averageArray)-averageTime)];
    averageTimeVSlevel(end+1,:) = [i,averageTime];
end
errorbar(averageTimeVSlevel(:,1), averageTimeVSlevel(:,2),neg(:,2),pos(:,2),'b-o','LineWidth', 2)
title('Computational Time vs. Fixed Ratio','FontSize', 16)
xlabel('Fixed Ratio','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)
