% plotTXT
% plots the input .txt files without using any other code

function [] = plotTXT(filename)
figure()
data = readData(filename); % get the size and shape from the data (this will tell you number of clusters points and so on)
X1 = data(:,1)';
X2 = data(:,4)';
Y1 = data(:,2)';
Y2 = data(:,5)';
plot([X1; X2], [Y1; Y2], 'color', 'r', 'linewidth', 2)
hold on;

for i = 1:length(X1)
    [cord,cord1,cord2] = createRectangle(X1(i),Y1(i),X2(i),Y2(i));
%     plot(cord1(:,1),cord1(:,2), 'linewidth',1)
%     plot(cord2(:,1),cord2(:,2), 'linewidth',1)
    plot(cord(:,1),cord(:,2), 'color', 'k', 'linewidth',2)

    
end

hold on
plot(0,0)
axis equal
% axis([-20 119 -9 101])
title('Input Boustrophedon Cells', 'FontSize', 16)
end