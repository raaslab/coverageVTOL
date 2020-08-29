% Dubin's plot for outputs/qualitativeExamples/journalQg*.mat (qualitative g)
% Look in GLNSplotter for the comment that says "Add these three lines of
% code if you are running dubinsPlot"
% Remove data from the legend that does not need to be there.

GLNSplotter

dubins_curve([19,3,0.86+3.14],[19,5,0.86],turnRadius,0.1)

dubins_curve([19,7,0.86+3.14],[11,15,-1.57],turnRadius,0.1)

dubins_curve([7,10,-1.57],[4,6,3.14],turnRadius,0.1)

dubins_curve([4,5,0],[4,1,3.14],turnRadius,0.1)

