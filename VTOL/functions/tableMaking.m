% tableMaking
% function creates a table to allow for the creation of the GTSP
% INPUTS
% x = x initial points
% y = y initial points that correspond to x
% numBatteryLevels
% OUTPUTS
% T = table that contains all information
% x = x points
% y = y points corresponding to x
% z = z levels corresponding to x

function [T, x, y, z] = tableMaking(x, y, numBatteryLevels)
xNew = [];
yNew = [];
zNew = [];
xTemp = transpose(x);
yTemp = transpose(y);
xTempSize = size(xTemp);
levels = [];

if xTempSize(1) == 1
    correctSize = xTempSize(2);
else
    correctSize = xTempSize(1);
end

for i = 1:correctSize
    levels(end+1) = numBatteryLevels;
end

levelsOrientation = size(levels);
xTemporientation = size(xTemp);

if levelsOrientation(1) ~= xTemporientation(1)
    levels = transpose(levels);
end
%groupNames = {'g1'; 'g2'; 'g3'};
T = table(xTemp, yTemp, levels);

%creating multiple x's, y's, & z's
for j = 1:correctSize
    for i = 1:numBatteryLevels
        xNew(end+1) = xTemp(j);
        yNew(end+1) = yTemp(j);
        zNew(end+1) = i;
    end
end

x = xNew;
y = yNew;
z = zNew;

end