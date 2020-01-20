% plots for ICRA 2019
% plots all of the time figures


dbstop error
clear all
close all
clc

% load timeData.mat
load timeVSi.mat
timeIall = timeI;
load timeVSi2.mat
timeIall = [timeIall;timeI];
load timeVSj.mat
timeJall = timeJ;
load timeVSj2.mat
timeJall = [timeJall;timeJ];
% load costVSbudget.mat
% load costVSbudgetGLNSOutput.mat
load glnsOutput.mat

% plot for cost vs budget
figure(1)
neg = [];
pos = [];
avgTimeVSsite = [];
for i = 1:41
    tempTimes = times(i, 2:11);
    averageTime = mean(tempTimes);
    neg(end+1,:) = [i,abs(min(tempTimes)-averageTime)];
    pos(end+1,:) = [i,abs(max(tempTimes)-averageTime)];
    avgTimeVSsite(end+1,:) = [times(i,1),averageTime];
end
% plot(times(:,1), times(:,5),'b-o', 'LineWidth',2,'MarkerFaceColor',[0,0,1])
% figure(4)
errorbar(avgTimeVSsite(:,1),avgTimeVSsite(:,2),neg(:,2), pos(:,2),'b-o','LineWidth', 2)

title('Cost vs. Budget','FontSize', 16)
xlabel('D_{max} (meters)','FontSize', 14)
ylabel('Tour Cost (seconds)','FontSize', 14)

% plot for time vs sites
figure(2)
neg = [];
pos = [];
avgTimeVSsite = [];

for i = 10:7:101
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
xlim([8,104])
% axis([8, 82,0,14])
title('Computational Time vs. Boustrophedon Cells', 'FontSize', 16)
xlabel('Number of Input Boustrophedon Cells','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)

% plot for time vs battery levels
figure(3)
neg = [];
pos = [];
averageTimeVSlevel =[];

for i = 10:7:101
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
xlim([8,104])
% axis([8,104,~,~])
title('Computational Time vs. Battery Levels','FontSize', 16)
xlabel('Number of Battery Levels','FontSize', 14)
ylabel('Computational Time (secondes)','FontSize', 14)

% plotTXT('inputs/costVSbudget1.txt')