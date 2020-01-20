% baselineMethod.m
% pulls in each polygon separately
% calculates the tour cost for each one
% connect each polygon

data = readData('inputs/fieldExperiments/exampleFigureBC1.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
x1 = [data(:,1), data(:,4)];
y1 = [data(:,2), data(:,5)];
[m,n] = size(x1);

x1New = [];
y1New = [];
for i = 1:m
    if mod(i,2)
        for j = 1:n
            x1New(end+1) = x1(i,j);
            y1New(end+1) = y1(i,j);
        end
    else
        for j = n:-1:1
            x1New(end+1) = x1(i,j);
            y1New(end+1) = y1(i,j);
        end
    end
end


data = readData('inputs/fieldExperiments/exampleFigureBC2.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
x2 = [data(:,1), data(:,4)];
y2 = [data(:,2), data(:,5)];
[m,n] = size(x2);

x2New = [];
y2New = [];
for i = 1:m
    if mod(i,2)
        for j = 1:n
            x2New(end+1) = x2(i,j);
            y2New(end+1) = y2(i,j);
        end
    else
        for j = n:-1:1
            x2New(end+1) = x2(i,j);
            y2New(end+1) = y2(i,j);
        end
    end
end


data = readData('inputs/fieldExperiments/exampleFigureBC3.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
x3 = [data(:,1), data(:,4)];
y3 = [data(:,2), data(:,5)];
[m,n] = size(x3);

x3New = [];
y3New = [];
for i = 1:m
    if mod(i,2)
        for j = 1:n
            x3New(end+1) = x3(i,j);
            y3New(end+1) = y3(i,j);
        end
    else
        for j = n:-1:1
            x3New(end+1) = x3(i,j);
            y3New(end+1) = y3(i,j);
        end
    end
end


data = readData('inputs/fieldExperiments/exampleFigureBC4.txt'); % get the size and shape from the data (this will tell you number of clusters points and so on)
x4 = [data(:,1), data(:,4)];
y4 = [data(:,2), data(:,5)];
[m,n] = size(x4);

x4New = [];
y4New = [];
for i = 1:m
    if mod(i,2)
        for j = 1:n
            x4New(end+1) = x4(i,j);
            y4New(end+1) = y4(i,j);
        end
    else
        for j = n:-1:1
            x4New(end+1) = x4(i,j);
            y4New(end+1) = y4(i,j);
        end
    end
end

xCon = [];
yCon = [];
xCon(end+1) = x1(1);
yCon(end+1) = y1(1);
xCon(end+1) = x1(end);
yCon(end+1) = y1(end);
xCon(end+1) = x2(1);
yCon(end+1) = y2(1);
xCon(end+1) = x2(end);
yCon(end+1) = y2(end);
xCon(end+1) = x3(1);
yCon(end+1) = y3(1);
xCon(end+1) = x3(end);
yCon(end+1) = y3(end);
xCon(end+1) = x4(1);
yCon(end+1) = y4(1);
xCon(end+1) = x4(end);
yCon(end+1) = y4(end);

j = 20;
tl = 45;
tto = 5;
r = 2;
max_distance = 1800;
totalDist0 = 0;
totalDist1 = 0;
totalDist2 = 0;
totalDist3 = 0;
totalDist4 = 0;
rechargeTimes = 0;
checkDist = 0;
for i = 1:length(xCon)-1
    tempDist0 = sqrt((xCon(i)-xCon(i+1))^2 + (yCon(i)-yCon(i+1))^2);
    checkDist = checkDist + tempDist0;
    if checkDist > max_distance
        rechargeTimes = rechargeTimes + 1;
        checkDist = tempDist0;
    end
    totalDist0 = totalDist0 + tempDist0;
end
checkDist = 0;
for i = 1:length(x1New)-1
    tempDist1 = sqrt((x1New(i)-x1New(i+1))^2 + (y1New(i)-y1New(i+1))^2);
    checkDist = checkDist + tempDist1;
    if checkDist > max_distance
        rechargeTimes = rechargeTimes + 1;
        checkDist = tempDist1;
    end
    totalDist1 = totalDist1 + tempDist1;
end
checkDist = 0;
for i = 1:length(x2New)-1
    tempDist2 = sqrt((x2New(i)-x2New(i+1))^2 + (y2New(i)-y2New(i+1))^2);
    checkDist = checkDist + tempDist2;
    if checkDist > max_distance
        rechargeTimes = rechargeTimes + 1;
        checkDist = tempDist2;
    end
    totalDist2 = totalDist2 + tempDist2;
    
end
checkDist = 0;
for i = 1:length(x3New)-1
    tempDist3 = sqrt((x3New(i)-x3New(i+1))^2 + (y3New(i)-y3New(i+1))^2);
    checkDist = checkDist + tempDist3;
    if checkDist > max_distance
        rechargeTimes = rechargeTimes + 1;
        checkDist = tempDist3;
    end
    totalDist3 = totalDist3 + tempDist3;
end
checkDist = 0;
for i = 1:length(x4New)-1
    tempDist4 = sqrt((x4New(i)-x4New(i+1))^2 + (y4New(i)-y4New(i+1))^2);
    checkDist = checkDist + tempDist4;
    if checkDist > max_distance
        rechargeTimes = rechargeTimes + 1;
        checkDist = tempDist4;
    end
    totalDist4 = totalDist4 + tempDist4;
end
totalDistanceUAV = totalDist0 + totalDist1 + totalDist2 + totalDist3 + totalDist4;

takelandCost = (tl+tto)*rechargeTimes;
rechargeCosts = r*j*rechargeTimes;
totalDistance = totalDistanceUAV + rechargeTimes + takelandCost + rechargeCosts


