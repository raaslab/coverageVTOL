% createRectangle.m

function [output, output1, output2] = createRectangle(x1, y1, x2, y2)

sensingRange = 0.5;
angle = atan2(y2-y1,x2-x1);

TL = [-sensingRange, +sensingRange];
TR = [+sensingRange, +sensingRange];
BR = [+sensingRange, -sensingRange];
BL = [-sensingRange, -sensingRange];
rotationMatrix = [cos(angle), -sin(angle); sin(angle), cos(angle)];
TL = (rotationMatrix*TL')';
TR = (rotationMatrix*TR')';
BR = (rotationMatrix*BR')';
BL = (rotationMatrix*BL')';
TL1 = TL + [x1,y1];
TR1 = TR + [x1,y1];
BR1 = BR + [x1,y1];
BL1 = BL + [x1,y1];
output1 = [TL1;TR1;BR1;BL1;TL1];

TL2 = TL + [x2,y2];
TR2 = TR + [x2,y2];
BR2 = BR + [x2,y2];
BL2 = BL + [x2,y2];
output2 = [TL2;TR2;BR2;BL2;TL2];

% find which point is on left
if x1<x2 && y1>y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1>x2 && y1>y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1>x2 && y1<y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1<x2 && y1<y2
    output = [BL1;TL1;TR2;BR2;BL1];
    
elseif x1==x2 && y1<y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1==x2 && y1>y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1>x2 && y1==y2
    output = [BL1;TL1;TR2;BR2;BL1];
elseif x1<x2 && y1==y2
    output = [BL1;TL1;TR2;BR2;BL1];
else
    output = [0;0;0;0;0];
    disp('error')
end

end