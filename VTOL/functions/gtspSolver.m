% gtspSolver
% solves the gtsp and outputs what is needed
% INPUTS
% v_Cluster = matrix that shows the node to cluster relationship
% v_Adj = matrix that shows the node to node (edge) relationships and the
% costs
% numPoints = number of inital points for creation of alpha_noon & beta_noon
% xOut = x point locations
% yOut = y point locations corresponding to x
% method = 1 is GLNS, 0 is concorde
% FDU = is the Fly Down Up edge created in makingSTWv_AdjGeneral.m
% groupedPoints = points grouped by original point not cluster
% x = original location of x coordinates
% y = original location of y coordinates
% UGVSpeed = speed of UGV
% maxDistance = budget of UAV
% v_Type = type of edge being used same for v_AdjChecker
% F = is the Fly edge created in makingSTWv_AdjGeneral
% v_ClusterLevels = battery level of every site
% OUTPUTS
% finalMatrix = the matrix that will be used to create UAV/UGV tours
% G_init = used for plotting purposes outside of the function
% weights = weights corresponding to the edges in finalMatrix
% finalTour = the finished transformed tour
% problem = means there was an error and this is not a valid run

function [finalMatrix, G_init, weights, finalTour, atspAdjMatrix, v_AdjChecker,v_Type] = gtspSolver(v_Cluster, v_Adj, numPoints, numLevels,method,groupedPoints, x,y,maxDistance,v_Type,v_ClusterLevels)

switch method
    case 0
        finalMatrix = 0;
        finalTour = 0;
        
        [G_init] = createNodeName(v_Adj);
        
        % [alpha_noon, problem] = createAlphaNoon(v_Adj, numPoints);
        [alpha_noon, problem1] = createAlphaNoon(v_Adj, numPoints, v_Cluster, numLevels);
        [beta_noon] = createBetaNoon(alpha_noon, numPoints);
        
        [s, t] = findedge(G_init);
        
        Adj_G_init = full(adjacency(G_init));
        Adj_G_init_ind = sub2ind(size(Adj_G_init), s(:),t(:));
        Adj_G_init(Adj_G_init_ind(:)) = G_init.Edges.Weight(:);
        
        [atspAdjMatrix, ~]  = gtsp_to_atsp(Adj_G_init, cell2mat(v_Cluster), alpha_noon, beta_noon, G_init);
        
        % [X_t, Y_s] = meshgrid(1:length(G_init.Nodes.Name), 1:length(G_init.Nodes.Name));
        [v_Cluster, atspAdjMatrix] = createBaseStation(v_Cluster, atspAdjMatrix, alpha_noon, beta_noon, numPoints, numLevels);                                  % creates the base station for v_Adj and v_Cluster
        [row, column, ~] = find(atspAdjMatrix > -1);
        G_atsp = digraph;
        [G_atsp] = createEdgesGTSP(G_atsp, row, column, atspAdjMatrix);
        
        
        G_atsp2_tsp = graph([], []);
        
        str_1node_intra = cellfun(@(x,y) sprintf('%s.1', x), G_atsp.Nodes.Name,'uni', 0);
        str_2node_intra = cellfun(@(x,y) sprintf('%s.2', x), G_atsp.Nodes.Name,'uni', 0);
        str_3node_intra = cellfun(@(x,y) sprintf('%s.3', x), G_atsp.Nodes.Name,'uni', 0);
        G_atsp2_tsp = addedge(G_atsp2_tsp, [str_1node_intra;str_2node_intra], [str_2node_intra;str_3node_intra], zeros(2*G_atsp.numnodes,1));
        
        str_1node = cellfun(@(x,y) sprintf('%s.1', x), G_atsp.Edges.EndNodes(:,1),'uni', 0);
        str_3node = cellfun(@(x,y) sprintf('%s.3', x), G_atsp.Edges.EndNodes(:,2),'uni', 0);
        G_atsp2_tsp = addedge(G_atsp2_tsp, str_1node,str_3node,G_atsp.Edges.Weight(:));
        
        nodes_totsp = G_atsp2_tsp.numnodes;
        edges_totsp = G_atsp2_tsp.numedges;
        
        % [Out_sol, ~] = TSP_tour_Dat(G_atsp2_tsp,'/home/klyu/software/concorde/concorde/TSP/concorde');
        
        [v_AdjChecker] = createBaseStationSimple(v_Adj, numPoints, numLevels);
        
        % [finalMatrix, finalTour, problem2] = concordeReconvert(G_atsp2_tsp, Out_sol, v_Cluster, v_AdjChecker, numLevels);
        
        [G_final, weights] = getWeights(G_init, finalMatrix, finalTour);
        
    case 1
        finalMatrix = 0;
        G_init = 0;
        weights = 0;
        finalTour = 0;
        atspAdjMatrix = 0;
%                 [v_AdjChecker] = createBaseStationSimple(v_Adj, numPoints, numLevels);
        [v_AdjChecker,v_Type] = createBaseStationComplex(v_Adj,numPoints,numLevels,v_Cluster,groupedPoints,x,y,maxDistance,v_Type,v_ClusterLevels);
        
end