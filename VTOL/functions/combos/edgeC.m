% MG

function [outputEdges] = edgeC(F, DTU, v_Cluster, distances, levels, sites, groupedPoints)
groupedPoints = cell2mat(groupedPoints);
outputEdges = Inf(sites*levels);
for i = 1:(sites*levels)
    j = 1;
    while j < (sites*levels)+1
        if v_Cluster(i) == v_Cluster(j)
            outputEdges(i,j) = Inf;
            j = j+1;
        else
            tempFind = v_Cluster(i);
            tempLocations = find((v_Cluster == tempFind) & (groupedPoints ~= groupedPoints(i)));
            if max(F(i,tempLocations) ~= Inf) == 1
                tempTempLocations = find(F(i,tempLocations) ~= Inf);
                middlePoint = tempLocations(tempTempLocations);
                tempPossiblePath = distances(groupedPoints(i),groupedPoints(middlePoint)) + DTU(middlePoint,j); % F + FDU
                outputEdges(i,j) = tempPossiblePath;
                j = j+1;
            else
                outputEdges(i,j) = Inf;
                j = j+1;
            end
            
        end
    end
end
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        if groupedPoints(i) == groupedPoints(j)
            outputEdges(i,j) = Inf;
        end
    end
end
end