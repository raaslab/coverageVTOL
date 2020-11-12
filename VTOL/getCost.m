% getCost.m
% gets the cost of a tour given the loaded .mat files and tour

clear
close all
load /home/klyu/coverageVTOL/VTOL/outputs/qualitativeExamples/journalQd1.mat
load /home/klyu/coverageVTOL/VTOL/outputs/qualitativeExamples/journalQd3.mat

GLNSSolution = [281, 22, 323, 64, 365, 106, 127, 428, 169, 470, 211, 273, 535, 237, 561] % qualitative b (only multi-rotor flight)
GLNSSolution = [281, 23, 325, 67, 369, 111, 135, 438, 163, 466, 209, 276, 532, 237, 561] % qualitative c (only multi-rotor with down up edges)
GLNSSolution = [281, 23, 325, 67, 369, 111, 122, 425, 168, 471, 481, 267, 532, 237, 561] % qualitative d (UGV travel edges)
% GLNSSolution = [501, 242, 543, 465, 146, 487, 168, 409, 390, 71, 312, 93, 334, 15, 561] % qualitative e (only fixed-wing flight)
% GLNSSolution = [521, 228, 541, 210, 475, 441, 146, 411, 398, 82, 346, 50, 314, 18, 561] % qualitative f (mix of all types of edges)
% GLNSSolution = [501, 248, 541, 491, 196, 441, 146, 411, 397, 81, 286, 30, 334, 78, 561] % qualitative g (with down up edges)
% GLNSSolution = [43, 1401, 1251, 608, 1365, 1226, 481, 1136, 391, 1017, 973, 227, 881, 135, 789] % qualitative h (fixed-wing with down up edges)
% GLNSSolution = [2421, 1125, 2469, 1173, 2517, 1204, 2548, 1252, 2596, 1281, 2625, 2410, 1073, 2377, 1022, 2327, 990, 2293, 897, 2199, 2180, 902, 2249, 956, 340, 1622, 283, 1585, 247, 1549, 212, 1515, 178, 1462, 126, 350, 1373, 2, 1349, 76, 1401, 108, 1695, 398, 1740, 2143, 808, 2113, 777, 2062, 726, 2030, 694, 1998, 641, 1946, 612, 1918, 561, 1864, 530, 1835, 421, 1766, 471, 1816, 2641]; % exampleBC plot
% GLNSSolution = [1, 1409, 217, 1625, 433, 1841, 1259, 2483, 601, 2049, 867, 2275, 1088, 2601] % Kentland Flight


totalCost = 0;
for i = 1:length(GLNSSolution)-1
    totalCost = totalCost + roundedGtspMatrix(GLNSSolution(i),GLNSSolution(i+1));
end
totalCost