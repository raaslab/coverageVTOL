% typeB
% creates fly, fly, down, up edge

%#ok<*FNDSB>

function [bEdge] = typeB(F, FDU, v_Cluster, distances, levels, sites, groupedPoints, aEdge, TO, L, RR)

bEdge =  aEdge;
groupedPoints = cell2mat(groupedPoints);
for i = 1:(sites*levels)
    j = 1;
    while j < (sites*levels)+1
        if v_Cluster(i) == v_Cluster(j)
            bEdge(i,j) = Inf;
            j = j+1;
        else
            tempFind = v_Cluster(i);
            tempLocations = find((v_Cluster == tempFind) & (groupedPoints ~= groupedPoints(i)));
            if max(F(i,tempLocations) ~= Inf) == 1
                tempTempLocations = find(F(i,tempLocations) ~= Inf);
                middlePoint = tempLocations(tempTempLocations);
                tempPossiblePaths = distances(groupedPoints(i),groupedPoints(middlePoint)) + FDU(middlePoint,j); % F + FDU
                bEdge(i,j) = tempPossiblePaths;
                j = j+1;
            else
                bEdge(i,j) = Inf;
                j = j+1;
            end
            
        end
    end
end
end