% createEdges
% creates all edges possible
% INPUTS
% G = graph
% numPoints = number of points within the graph
% OUTPUTS
% G = graph

function [G] = createEdgesFull(G, numPoints)
for i = 1:numPoints
    for j = i:numPoints
        if i ~= j
            s = i;
            t = j;
            G = addedge(G, s, t);
        end
    end
end
end