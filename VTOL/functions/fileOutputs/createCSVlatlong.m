% createCSVlatlong.m
% creates a .csv for https://www.darrinward.com/lat-long/

function [] = createCSVlatlong(filename, latlongele)

fileID = fopen(filename,'w');

fprintf(fileID, 'latitude,longitude,name,color\n');

for i = 1:length(latlongele)
    fprintf(fileID, '%d,%d,%d,#FFFF00\n', latlongele(i,1),latlongele(i,2),i);
end

fclose(fileID);

end