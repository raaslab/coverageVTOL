% polygonCreater.m
% creates n number of line segments which represent the middle line of a
% polygon.
% INPUT
% fileName: the name of the file, saved in local directory
% numberOfPolygons: the number of random rectangular strips
% randNum: number is uniformily choosen from [1,randNum] when randomly created
% showFigs: 1 == show, 0 == don't show
% TSPReplica: 1 == make unit size of rectangles; 0 == random size rectangles
% belowNum: if TSPReplica == 0, then below this number

function [] = polygonCreater(fileName,numberOfPolygons,randNum,showFigs,TSPReplica)

x1 = Inf([1,numberOfPolygons]);
y1 = Inf([1,numberOfPolygons]);
x2 = Inf([1,numberOfPolygons]);
y2 = Inf([1,numberOfPolygons]);
[x1, y1, x2, y2] = updateXYs(x1, y1, x2, y2, 1, 'rand', 1, randNum,TSPReplica);

i = 2;
while i < numberOfPolygons+1
    repeat = 0;
    [x1, y1, x2, y2] = updateXYs(x1, y1, x2, y2, i, 'rand', 1, randNum,TSPReplica);
    newLine = [x1(i), y1(i), x2(i), y2(i)]; % get new line
    
    for j = 1:i-1
        tempLine = [x1(j), y1(j), x2(j), y2(j)]; % get all previous lines
        if isequal(tempLine,newLine) % check if the points are the same
            repeat = 1;
        end
        intersect = lineSegmentIntersect(tempLine, newLine); % check if lines intersect
        if intersect.intAdjacencyMatrix == 1
            [x1, y1, x2, y2] = updateXYs(x1, y1, x2, y2, i, Inf, 0, randNum,TSPReplica); % remove newline segment
            repeat = 1;
            break;
        end
    end
    
    if repeat == 0
        i = i+1;
    end
    
%     tempX1 = x1; tempY1 = y1; tempX2 = x2; tempY2 = y2;
%     tempX1(isinf(x1)) = []; tempY1(isinf(y1)) = []; tempX2(isinf(x2)) = []; tempY2(isinf(y2)) = [];
    
%     clf
%     hold on
%     for j = 1:length(tempX1)
%         figure(1)
%         plot([tempX1; tempX2], [tempY1; tempY2]);
%         axis equal
%     end
end

ugvPossible1 = ones([1, length(x1)]);
ugvPossible2 = ones([1, length(x2)]);

createPolygonFile(fileName, x1, y1, ugvPossible1, x2, y2, ugvPossible2)
if showFigs == 0
    close all;
end

end
