% MDU F
% creates multi, down, up, fixed edge

function [output] = edgeS(F, MDU, v_Cluster, levels, sites, groupedPoints)
groupedPoints = cell2mat(groupedPoints);
output = Inf(sites*levels);
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        conA = find(v_Cluster(i) == v_Cluster);
        conB = find(groupedPoints(i) ~= groupedPoints);
        indexOfFirstLeg = intersect(conA, conB);
        firstLeg = Inf([1,length(indexOfFirstLeg)]);
        for k = 1:length(indexOfFirstLeg)
            firstLeg(k) = MDU(i,indexOfFirstLeg(k));
        end
        secondLeg = [];
        for k = 1:length(firstLeg)
            secondLeg(end+1) = F(indexOfFirstLeg(k),j);
        end
        bothLegs = firstLeg + secondLeg;
        output(i,j) = min(bothLegs);
    end
end
for i = 1:(sites*levels)
    for j = 1:(sites*levels)
        if groupedPoints(i) == groupedPoints(j)
            output(i,j) = Inf;
        end
    end
end
end