% updateXYs
% updates the values of x1, y1, x2, y2 based on what is needed
% (value,random number, random number a single unit away).
% INPUT
% location: location in array of new element
% value: value to be placed at location
% valueOrRandom: 1 == random value, 0 == value=value
% randNum: [1,randNum] for choosing random value
% TSPReplica: 1 == unit rectangles,0 == random size rectangles

function [x1, y1, x2, y2] = updateXYs(x1, y1, x2, y2, location, value, valueOrRandom, randNum, TSPReplica)

if TSPReplica == 1 % make rectangles only 1 unit
    x1(location) = randi(randNum,1);
    y1(location) = randi(randNum,1);
    choice = randi(4,1);
    if choice == 1
        x2(location) = x1(location);
        y2(location) = y1(location)+1;
    elseif choice == 2
        x2(location) = x1(location)+1;
        y2(location) = y1(location);
    elseif choice == 3
        x2(location) = x1(location);
        y2(location) = y1(location)-1;
    elseif choice == 4
        x2(location) = x1(location)-1;
        y2(location) = y1(location);
    else
        disp('error')
    end
elseif valueOrRandom == 1
    x1(location) =  randi(randNum,1);
    y1(location) =  randi(randNum,1);
    x2(location) =  randi(randNum,1);
    y2(location) =  randi(randNum,1);
else
    x1(location) = value;
    y1(location) = value;
    x2(location) = value;
    y2(location) = value;
end


end