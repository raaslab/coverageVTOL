% RSR, RSL, LSR, LSL, RLR, LRL

% p = [x, y, theta]
% r = 4


p1x = randi([0,100]);
p1y = randi([0,100]);
p1theta = 2*pi*rand;
p2x = randi([0,100]);
p2y = randi([0,100]);
p2theta = 2*pi*rand;
p1 = [p1x,p1y,p1theta];
p2 = [p2x,p2y,p2theta];
r = randi([1,10]);
stepsize = -1;
quiet = false;

param = dubins_core(p1, p2, r);
path = dubins_curve(p1, p2, r, stepsize, quiet);