%% Path planning in 3D indoor environment using RRT
clear all;
clc;
%% DECLARATION OF THE WORKSPACE: Indoor Environment
%% Declare the obstacles:
%obstacle 1: Wall with a small slit defined using meshes
vertices1 = [750, 0, 0; 750, 0, 1000; 750, 1000, 1000; 750, 1000, 0;...
 800, 1000, 0; 800, 1000, 1000; 800, 0, 1000; 800, 0, 0;...
 750, 500, 400; 750, 500, 700; 750, 800, 700; 750, 800, 300;...
 800, 800, 300; 800, 800, 700; 800, 500, 700; 800, 500, 400];

faces1 = [1 2 7 8; 2 3 6 7; 3 4 5 6; 4 1 8 5; 1 9 10 2; 10 11 3 2; 11 12 4 3;...
 12 9 1 4; 8 16 15 7; 15 14 6 7; 14 13 5 6; 13 16 8 5; 9 10 15 16;...
 10 11 14 15; 11 12 13 14; 9 16 13 12;];

% obstacle 2 : Wall
vertices2 = [200, 300, 0; 250, 300, 0; 250, 1000, 0; 200, 1000, 0;...
 200, 300, 1000; 250, 300, 1000; 250, 1000, 1000; 200, 1000, 1000];
faces2 = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
% obstacle 3: pillar in the room
cylinder = [500 500 0 500 500 800 50];
%% Declare the Start and Goal points using the structure:
Startpt.coord = [50,50,50];
Startpt.parent = 0;
Startpt.cost = 0;
Goalpt.coord = [900,900,900];
Goalpt.parent = 0;
Goalpt.cost = 0;
%% Display the workspace:
figure(1)
axis([0 1000 0 1000 0 1000])
hold on;
title('Path planning in 3D using RRT')
hold on;
scatter3([Startpt.coord(1) Goalpt.coord(1)],[Startpt.coord(2) Goalpt.coord(2)],...
 [Startpt.coord(3) Goalpt.coord(3)],'filled', 'b'); hold on;
drawMesh(vertices1, faces1,'b'); hold on; light;
drawMesh(vertices2, faces2,'g'); hold on; light;
drawCylinder(cylinder, 'FaceColor','y'); light;
hold on
%% Rapidly exploring Random Tree (RRT) with single seed at start point:
% Parameters used in RRT:
% Maximum no. of nodes and step size between parent & child node of tree
Max_nodes = 1000;
step = 50;
% Nodes: array which stores all the nodes in the tree
Nodes(1) = Startpt;
count = 1;
while count < Max_nodes
 % Generate random point in the workspace
 RandNode = [floor(rand(1)*1000) floor(rand(1)*1000) floor(rand(1)*1000)];
 D = 2*1000; %D is initialised to maximum distance
 CloseNode = Startpt; %Closest node is initialised as Start point

 %% Find the closest node to the random node
 for j = 1:length(Nodes)
 dist2j = norm(Nodes(j).coord-RandNode);
 if dist2j < D
 D = dist2j;
 CloseNode = Nodes(j);
 k = j;
 end
 end
 % New node is generated in the same direction as that of random node
 % with the distance between closest and new node = step size
 NewNode = CloseNode.coord + step*(RandNode-CloseNode.coord)/D;

 %% Check the intersection of the obstacles with the line between closest
 %% node and the new node
 line=[CloseNode.coord NewNode];
 points1 = intersectLineMesh3d(line, vertices1, faces1);
 points2 =intersectLineMesh3d(line, vertices2, faces2);
 points3 = intersectLineCylinder(line, cylinder);
 if ~isempty(points1) || ~isempty(points2) || ~isempty(points3)
 continue
 end
 % draw the line between the new node and the closest node
 plot3([NewNode(1) CloseNode.coord(1)], [NewNode(2) CloseNode.coord(2)],...
 [NewNode(3) CloseNode.coord(3)],'Color','k');
 drawnow
 hold on

 %% New point is added to the Nodes array
 Newpt.coord = NewNode;
 Newpt.parent = k;
 Newpt.cost = Nodes(k).cost + D;
 Nodes = [Nodes Newpt];
 count = count + 1;
end
%% Find the distance of the closest node to the goal point
D = 3000;
for j = 1:length(Nodes)
 dist2j = dist(Nodes(j).coord, Goalpt.coord');
 if dist2j < D
 D = dist2j;
 k = j;
 end
end
Goalpt.parent = k;
Nodes = [Nodes Goalpt];
p = length(Nodes);
%% Trace back the path generated from the goal point to start point
while Nodes(p).parent>0
 plot3([Nodes(p).coord(1), Nodes(Nodes(p).parent).coord(1)],...
 [Nodes(p).coord(2), Nodes(Nodes(p).parent).coord(2)],...
 [Nodes(p).coord(3), Nodes(Nodes(p).parent).coord(3)],'Color' ,'r','LineWidth', 2)
 drawnow;
 hold on
 p = Nodes(p).parent;
end
