% graphingGTSP
% graphs the 3D GTSP problem on a 2D plane with the cluster grouping
% INPUTS
% x = x corrdinates
% y = y corrdinates
% numPoints = number of initial points in the graph
% numLevels = number of initial level given for the graph
% s = starting node for an edge
% t = corresponding ending node for an edge with "s"
% id = name of nodes within graph
% withBaseStation = character array that states if it has a base station
% 'yes' or it doesn't have one anything else
% id = the names of the points
% OUTPUTS
% this function just plots the cluster so no output is needed

function [xOut, yOut] = graphingCluster(x, y, numPoints, numLevels, s, t, withBaseStation, id, method)

switch method
    case 0
        xOut = [];
        yOut = [];
        
        G = digraph;
        for i = 1:numPoints
            count = numLevels;
            for j = 1:numLevels
                xOut(end+1) = i;
                yOut(end+1) = count;
                count = count-1;
            end
        end
        
        [G, xOut, yOut] = graphMakingWPoints(xOut, yOut, G, id);
        [G] = createEdges(G, s, t);
        
        if strcmp(withBaseStation, 'yes')
            xOut(end+1) = 0;
            yOut(end+1) = 0;
        end
        
        % figure()                                                            % plots graph
        % plot(G, 'XData', xOut, 'YData', yOut, 'LineStyle', '-.', 'LineWidth', 2, 'MarkerSize', 2);
        
        yRec = 0;
        wRec = 1;
        hRec = numLevels+1;
        for i = 1:numPoints                                                 % clusters the points
            xRec = i-(wRec/2);                                              % parameters for creating clusters
            pos = [xRec, yRec, wRec, hRec];                                 % creates oval, but needs to be fixed
            rectangle('Position', pos, 'Curvature', [1 1])
            xStr = num2str(x(i));
            yStr = num2str(y(i));
            str = sprintf('%s, %s', xStr, yStr);
            text(xRec, yRec+hRec-(hRec/16), str, 'Color', 'red', 'Fontsize', 7);
        end
        
    case 1
        xOut = [];
        yOut = [];
        
        G = digraph;
        for i = 1:numPoints
            count = numLevels;
            for j = 1:numLevels
                xOut(end+1) = i;
                yOut(end+1) = count;
                count = count-1;
            end
        end
        
        [G, xOut, yOut] = graphMakingWPoints(xOut, yOut, G, id);
%         [G] = createEdges(G, s, t);
        
        if strcmp(withBaseStation, 'yes')
            xOut(end+1) = 0;
            yOut(end+1) = 0;
        end
        
end




