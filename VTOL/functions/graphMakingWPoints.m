% graphMakingWPoints
% 2 inputs: creates a directional graph
% 3 inputs: addes the points to an already existing graph
% INPUTS
% x = array of x corrdinates
% y = array of y corrdinates
% G = if there is a graph already made you want to add the points too
% id = name of nodes within the graph
% OUTPUTS
% G = graph
% x = x after duplicated
% y = y after duplicated


function [G, x, y] = graphMakingWPoints(x, y, G, id)

switch nargin
    case 4
        idNew = arrayfun(@(x) num2str(x), id, 'UniformOutput', false);
        G = addnode(G, idNew);
    case 2
        G = digraph;
        numPoints = numel(x);
        G = addnode(G, numPoints);
end

% figure()
% plot(G, 'XData', x, 'YData', y)



end