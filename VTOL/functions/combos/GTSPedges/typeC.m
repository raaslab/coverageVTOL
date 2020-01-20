% typeC
% creates fly, down, up, fly, down, up edge

function [cType] = typeC(FDU, v_Cluster, levels, sites, groupedPoints, aEdge, TO, L, RR)

groupedPoints = cell2mat(groupedPoints);
cType = Inf(sites*levels);
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        conA = find(v_Cluster(i) == v_Cluster);
        conB = find(groupedPoints(i) ~= groupedPoints);
        indexOfFirstLeg = intersect(conA,conB);
        firstLeg = Inf([1,length(indexOfFirstLeg)]);
        for k = 1:length(indexOfFirstLeg)
            firstLeg(k) = FDU(i,indexOfFirstLeg(k));
        end
        secondLeg = [];
        for k = 1:length(firstLeg)
            secondLeg(end+1) = FDU(indexOfFirstLeg(k),j);
        end
        bothLegs = firstLeg + secondLeg;
        cType(i,j) = min(bothLegs);
    end
end

for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        if groupedPoints(i) == groupedPoints(j)
            cType(i,j) = Inf;
        end
    end
end

end