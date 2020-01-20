% plotPicture.m
% plots a .png image and allows you to click to store locations of vertices

figure()
yourImage = imread('figures/kentlandVideoBC.png');
imshow(yourImage);
hold on;
% impoint
% x = [0,0]
% y = [50,100]
% plot(x, y, 'r*', 'LineWidth', 2, 'MarkerSize', 15);
x = [100];  
y = [50];
plot(x, y, 'b*', 'LineWidth', 2, 'MarkerSize', 15);
[x1,y1] = ginput;
[x2,y2] = ginput;

ugvPossible1 = ones([1, length(x1)]); % all one side of rectangles
ugvPossible2 = ones([1, length(x2)]); % corresponding other side of rectangles
createPolygonFile('/home/klyu/lab/coverageWork/coverage/GTSP/inputs/fieldExperiments/kentlandVideo.txt', x1, y1, ugvPossible1, x2, y2, ugvPossible2)