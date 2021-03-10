clear;clc;
load('outputs/costVSbudget/glnsBudget.mat')

xData = 10:50;
IDs = [];
avg = [];
negData = [];
posData = [];
for i = 10:50
    tempIDs = find(budgets(:,2)==i);
    IDs(end+1,:) = tempIDs;
    tempData = nan(1,length(tempIDs));
    for j = 1:length(tempIDs)
        tempData(j) = budgets(tempIDs(j),3);
    end
    avg(end+1) = mean(tempData);
    negData(end+1) = min(tempData)-mean(tempData);
    posData(end+1) = max(tempData)-mean(tempData);
end
yData = avg;

errorbar(xData,yData,negData,posData,'b-o','LineWidth', 2)
title('Cost vs. Budget','FontSize', 16)
xlabel('D_{max} (meters)','FontSize', 14)
ylabel('Tour Cost (seconds)','FontSize', 14)
