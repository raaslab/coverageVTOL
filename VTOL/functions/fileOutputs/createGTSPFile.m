% createGTSPFile
% creates the file for GLNS input

function [] = createGTSPFile(filename, matrix, vertices, batteryLevels, v_Clusters)

v_Clusters = cell2mat(v_Clusters);

fileID = fopen(filename,'w');

fprintf(fileID, 'NAME: TEST\n');
fprintf(fileID, 'TYPE: AGTSP\n');
fprintf(fileID, 'COMMENT: NA\n');
fprintf(fileID, 'DIMENSION:  %d\n', (vertices*batteryLevels)+1);
fprintf(fileID, 'GTSP_SETS: %d\n', (vertices/2)+1);
fprintf(fileID, 'EDGE_WEIGHT_TYPE: EXPLICIT\n');
fprintf(fileID, 'EDGE_WEIGHT_FORMAT: FULL_MATRIX\n');
fprintf(fileID, 'EDGE_WEIGHT_SECTION\n');
% fprintf(fileID, '%d\n', matrix');
for i = 1:(vertices*batteryLevels)+1
    fprintf(fileID, '%d ', matrix(i,:)');
    fprintf(fileID, '\n');
end

fprintf(fileID, 'GTSP_SET_SECTION:\n');

counter = 1;
for i = 1:(vertices/2)
    fprintf(fileID, '%d', i);
    tempSites = find(v_Clusters == i);
    for j = 1:length(tempSites)
        fprintf(fileID, ' %d', tempSites(j));
        counter = counter + 1;
    end
    fprintf(fileID, ' -1\n');
end

fprintf(fileID, '%d %d -1\n', (vertices/2)+1, counter);
fprintf(fileID, 'EOF');

fclose(fileID);

end