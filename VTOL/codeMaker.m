load('./outputs/fieldExperiments/kentLand1_1.mat')
load('./outputs/fieldExperiments/kentLand1_3.mat')

name = 'test.py';
aORb = ["a","b"];
flightModes = ['m','f','g'];

fileID = fopen(name, 'w');
fprintf(fileID, '#!/usr/bin/env python3.7\n');
fprintf(fileID, 'import gurobipy as gp\n');
fprintf(fileID, 'from gurobipy import GRB\n\n');

fprintf(fileID, 'try:\n');
fprintf(fileID, '\t# Create a model:\n');
fprintf(fileID, '\tm = gp.model("model")\n\n');

nodeVariableNames = string([]);
allDecisionVariables = string([]);
fprintf(fileID, '\t# Create variables:\n');
numClusters = 3;
numBatteryLevels = 2;
for i = 1:numClusters % creating node variables
    for j = 1:length(aORb)
        for k = 1:length(flightModes)
            for l = 1:numBatteryLevels
                name = string(i) + aORb(j) + flightModes(k) + string(l);
                nodeVariableNames(end+1) = string(name);
                fprintf(fileID, '\tvar');
                fprintf(fileID, name);
                fprintf(fileID, ' = m.addVar(vtype = GRB.BINARY, name = "var');
                fprintf(fileID, name);
                fprintf(fileID, '")\n');
            end
        end
    end
end
for i = 1:length(nodeVariableNames)
    for j = 1:length(nodeVariableNames)
        if i~=j
            allDecisionVariables(end+1) = nodeVariableNames(i) + nodeVariableNames(j);
            fprintf(fileID, '\tvar');
            fprintf(fileID, nodeVariableNames(i) + nodeVariableNames(j));
            fprintf(fileID, ' = m.addVar(vtype = GRB.BINARY, name = "var');
            fprintf(fileID, nodeVariableNames(i) + nodeVariableNames(j));
            fprintf(fileID, '")\n');
        end
    end
end

% # TODO: write objective here
% # TODO: fix this objective function
fprintf(fileID, "\n\t# Set objective:\n");
fprintf(fileID, "\tm.setObjective(");
count = 0;
for i = 1:length(nodeVariableNames)
    for j = 1:length(nodeVariableNames)
        if i~=j
            fprintf(fileID, "var" + nodeVariableNames(i) + nodeVariableNames(j));
            count = count + 1;
            if count < (length(nodeVariableNames)*(length(nodeVariableNames)-1))
                fprintf(fileID, " + ");
            end
        end
    end
end

fprintf(fileID, ", GRB.MINIMIZE)\n");
% # GRB.INFINITY

% write constraints here
fprintf(fileID, '\n\t# Add constraints:\n');
% node coverage constraints
fprintf(fileID, '\t# node constraints\n');
for i = 1:numClusters
    for j = 1:length(aORb)
        writeNodeConstraint = string([]);
        for k = 1:length(flightModes)
            for l = 1:numBatteryLevels
                if flightModes(k) ~= 'g'
                    writeNodeConstraint(end+1) = (string(i) + aORb(j) + flightModes(k) + string(l));
                end
            end
        end
        if ~isempty(writeNodeConstraint)
            fprintf(fileID, '\tm.addConst(');
            for m = 1:length(writeNodeConstraint)
                fprintf(fileID, 'var' + writeNodeConstraint(m));
                if writeNodeConstraint(m) ~= writeNodeConstraint(end)
                    fprintf(fileID, ' + ');
                end
            end
            fprintf(fileID, ' >= 1, "c' + string(i) + aORb(j) + '")\n');
        end
    end
end
% bc coverage constraints
fprintf(fileID, '\t# bc coverage constraints\n');
for i = 1:numClusters
    writeEdgeConstraint = string([]);
    singleBC = string([]);
    for j = 1:length(nodeVariableNames)
        charNodeVariableName = convertStringsToChars(nodeVariableNames(j));
        if(charNodeVariableName(1) == string(i))
            singleBC(end+1) = nodeVariableNames(j);
        end
    end
    for j = 1:length(singleBC)
        for k = 1:length(singleBC)
            if j ~= k
                if((contains(singleBC(j),'am') && contains(singleBC(k),'bm')) || (contains(singleBC(j),'bm') && contains(singleBC(k),'am')) || (contains(singleBC(j),'af') && contains(singleBC(k),'bf')) || (contains(singleBC(j),'bf') && contains(singleBC(k),'af')))
                    writeEdgeConstraint(end+1) = singleBC(j) + singleBC(k);
                end
            end
        end
    end
    if ~isempty(writeEdgeConstraint)
        fprintf(fileID, '\tm.addConst(');
        for j = 1:length(writeEdgeConstraint)
             fprintf(fileID, 'var' + writeEdgeConstraint(j));
             if writeEdgeConstraint(j) ~= writeEdgeConstraint(end)
                 fprintf(fileID, ' + ');
             end
        end
        fprintf(fileID, ' == 1, "c' + string(i) + '")\n');
    end
end
% exactly 1 input constraint
fprintf(fileID, "\t# input constraints\n");
for i = 1:length(nodeVariableNames)
    count = 0;
    fprintf(fileID, "\tm.addConst(");
    for j = 1:length(nodeVariableNames)
        if i ~= j
            fprintf(fileID, "var" + nodeVariableNames(i) + nodeVariableNames(j));
            if count < length(nodeVariableNames)-2
                fprintf(fileID, " + ");
                count = count + 1;
            end
        end
    end
    fprintf(fileID, ' <= 1, "ci' + nodeVariableNames(i) + '")\n');
end
% exactly 1 output constraint
fprintf(fileID, "\t# output constraints\n");
for i = 1:length(nodeVariableNames)
    count = 0;
    fprintf(fileID, "\tm.addConst(");
    for j = 1:length(nodeVariableNames)
        if i ~= j
            fprintf(fileID, "var" + nodeVariableNames(j) + nodeVariableNames(i));
            if count < length(nodeVariableNames)-2
                fprintf(fileID, " + ");
                count = count + 1;
            end
        end
    end
    fprintf(fileID, ' <= 1, "co' + nodeVariableNames(i) + '")\n');
end

fprintf(fileID, '\n\t# Optimize model:\n');
fprintf(fileID, '\tm.optimize()\n\n');

% prints answer
fprintf(fileID, '\tfor v in m.getVars():\n');
fprintf(fileID, '\t\tprint(''%%s %%g'' %% (v.varName, v.x))\n\n');

fprintf(fileID, '\tprint(''Obj: %%g'' %% m.objVal)\n\n');

% errors codes
fprintf(fileID, 'except gp.GurobiError as e:\n');
fprintf(fileID, '\tprint(''Error code '' + str(e.errno) + '': '' + str(e))\n\n');

fprintf(fileID, 'except AttributeError:\n');
fprintf(fileID, '\tprint(''Encountered an attribute error'')\n');

fclose(fileID);