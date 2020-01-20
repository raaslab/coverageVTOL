% createPolygonFile.m
% Creates the input polygon file for specificRuns.m. This is called in
% polygonCreater.m

function [] = createPolygonFile(filename, x1, y1, ugvPossible1, x2, y2, ugvPossible2)

fileID = fopen(filename,'w');

for i = 1:length(x1)-1
    fprintf(fileID, '%d %d %d %d %d %d\n', x1(i), y1(i), ugvPossible1(i), x2(i), y2(i), ugvPossible2(i));
end
i = i+1;
fprintf(fileID, '%d %d %d %d %d %d', x1(i), y1(i), ugvPossible1(i), x2(i), y2(i), ugvPossible2(i));


fclose(fileID);


end