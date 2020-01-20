% checkUGVPossibility
% removes edges that go to sites that are not UGV accessable
% INPUT
% checker: checker == 0 check only first point, checker == 1 check only last point, checker == 2 check both points
% OUTPUT
%

function [outputMatrix] = checkUGVPossibility(inputMatrix, UGVPossible, checker)

outputMatrix = inputMatrix;
[n,m] = size(inputMatrix);
if checker == 0
    for i = 1:n
        for j = 1:m
            if UGVPossible(i) == 0
                outputMatrix(i,j) = Inf;
            end
        end
    end
elseif checker == 1
    for i = 1:n
        for j = 1:m
            if UGVPossible(j) == 0
                outputMatrix(i,j) = Inf;
            end
        end
    end
elseif checker == 2
    for i = 1:n
        for j = 1:m
            if UGVPossible(i) == 0
                outputMatrix(i,j) = Inf;
            elseif UGVPossible(j) == 0
                outputMatrix(i,j) = Inf;
            end
        end
    end
end

end