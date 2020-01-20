% F MDU
% creates multi, fixed, down, up edge

function [output] = edgeW(F, MDU, v_Cluster, distances, levels, sites, groupedPoints, aEdge)
output =  aEdge;
groupedPoints = cell2mat(groupedPoints);
for i = 1:(sites*levels)
    j = 1;
    while j < (sites*levels)+1
        if v_Cluster(i) == v_Cluster(j)
            output(i,j) = Inf;
            j = j+1;
        else
            tempFind = v_Cluster(i);
            tempLocations = find((v_Cluster == tempFind) & (groupedPoints ~= groupedPoints(i)));
            if max(F(i,tempLocations) ~= Inf) == 1
                tempTempLocations = find(F(i,tempLocations) ~= Inf);
                middlePoint = tempLocations(tempTempLocations);
                tempPossiblePaths = distances(groupedPoints(i),groupedPoints(middlePoint)) + MDU(middlePoint,j); % F + MDU
                output(i,j) = tempPossiblePaths;
                j = j+1;
            else
                output(i,j) = Inf;
                j = j+1;
            end
        end
    end
end
end