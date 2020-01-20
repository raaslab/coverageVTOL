% typeD
% creates fly, down, up, fly edge

function [dType] = typeD(F, FDU, v_Cluster, levels, sites, groupedPoints, aEdge, TO, L, RR)

groupedPoints = cell2mat(groupedPoints);
dType = Inf(sites*levels);
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        conA = find(v_Cluster(i) == v_Cluster);
        conB = find(groupedPoints(i) ~= groupedPoints);
        indexOfFirstLeg = intersect(conA, conB);
        firstLeg = Inf([1,length(indexOfFirstLeg)]);
        for k = 1:length(indexOfFirstLeg)
            firstLeg(k) = FDU(i,indexOfFirstLeg(k));
        end
        secondLeg = [];
        for k = 1:length(firstLeg)
            secondLeg(end+1) = F(indexOfFirstLeg(k),j);
        end
        bothLegs = firstLeg + secondLeg;
        dType(i,j) = min(bothLegs);
    end
end

for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        if groupedPoints(i) == groupedPoints(j)
            dType(i,j) = Inf;
        end
    end
end

end