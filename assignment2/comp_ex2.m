close all;
clear;

% load images and data
im1 = imread("data/cube1.JPG");
im2 = imread("data/cube2.JPG");
load('data/compEx3data.mat');

% normalize the measured projections of the model points for each image,
% to yield better results with the DLT computations
normPoints1 = normalize_points_for_DLT(x{1});
normPoints2 = normalize_points_for_DLT(x{2});


% plot the normalized points in the 2 views
figure;
subplot(1, 2, 1);
plot(normPoints1(1, :), normPoints1(2, :),'*');
title('Normalized points of the view 1');
subplot(1, 2, 2);
plot(normPoints2(1, :), normPoints2(2, :),'*');
title('Normalized points of the view 2');
% for each view, the points are centered in (0, 0) with std = 1


% use DLT to perform Camera resectioning
% QUESTION: u should solve it for each image right??
sol1 = estimate_camera_DLT(Xmodel, normPoints1);
disp("smallest singular value of the solution for the point for view1: " + min(sol1));
disp("value of ||Mv|| for view1: " + norm(cross(normPoints1, Xmodel) * sol1));
sol2 = estimate_camera_DLT(Xmodel, normPoints2);
disp("smallest singular value of the solution for the point for view1: " + min(sol2));
disp("value of ||Mv|| for view2: " + norm(cross(normPoints2, Xmodel) * sol2));
% in all 4 cases, the values seems to be close to 0

% use the 2 solutions to compute P1 and P2
P1 = reshape(sol1(1:12) ,[4 3])';
P2 = reshape(sol2(1:12) ,[4 3])';

