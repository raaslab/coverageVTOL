% makingV_Cluster
% INPUTS
% numOfPoints = how many clusters you want
% numLevels = how many duplicated points for the cluster
% OUTPUTS
% V_Cluster = input for GTSP solver

function [groupedPoints] = makingGroupedPoints(numOfPoints, numLevels)


count = 1;
for i = 1:numOfPoints
    for j = 1:numLevels
        groupedPoints(count, :) = i;
        count = count+1;
    end
end
% 
% for i = 1:numOfPoints/2
%     for j = 1:numLevels
%         V_cluster(count, :) = i;
%         count = count+1;
%     end
% end

end