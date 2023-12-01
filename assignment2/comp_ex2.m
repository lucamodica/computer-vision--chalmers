close all;
clear;

% load images and data
im1 = imread("data/cube1.JPG");
im2 = imread("data/cube2.JPG");
load('data/compEx3data.mat');

N1 = standardization_mat(x{1});
N2 = standardization_mat(x{2});

% for the optional part (comment the row for the original exercise)
% N1 = eye(3,3);

% normalize the measured projections of the model points for each image,
% to yield better results with the DLT computations
disp("view1:");
normPoints1 = N1 * x{1};

% for the second part of the optional (have to filter the 2D points 
% for view1 and the 3D points) (comment the rows below for the 
% original exercise)
% normPoints1 = N1 * x{1}(:, [1 4 13 16 25 28 31]);
% XmodelFiltered = Xmodel(:, [1 4 13 16 25 28 31]);

disp("view2:");
normPoints2 = N2 * x{2};


% plot the normalized points in the 2 views
figure;
subplot(1, 2, 1);
plot(normPoints1(1, :), normPoints1(2, :),'*');
title('Normalized points of the view 1');
subplot(1, 2, 2);
plot(normPoints2(1, :), normPoints2(2, :),'*');
title('Normalized points of the view 2');
% for each view, the points are centered in (0, 0) since the
% mean is close to 0 for each coordinate and image point set
disp("Mean of x axis in x{1}: " + mean(normPoints1(1, :)));
disp("Mean of y axis in x{1}: " + mean(normPoints1(2, :)));
disp("Mean of x axis in x{2}: " + mean(normPoints2(1, :)));
disp("Mean of y axis in x{2}: " + mean(normPoints2(1, :)));

% for each coordinate and image point set, std = 1
disp("Standard deviation of x axis in x{1}: " + std(normPoints1(1, :)));
disp("Standard deviation of y axis in x{1}: " + std(normPoints1(2, :)));
disp("Standard deviation of x axis in x{2}: " + std(normPoints2(1, :)));
disp("Standard deviation of y axis in x{2}: " + std(normPoints2(1, :)));


% use DLT to perform Camera resectioning
sol1 = estimate_camera_DLT(Xmodel, normPoints1);

% optional exercise version (comment for the original)
% sol1 = estimate_camera_DLT(XmodelFiltered, normPoints1);

disp("smallest singular value of the solution for the point for view1: " + min(sol1));
disp("value of ||Mv|| for view1: " + norm(DLT_matrix(Xmodel, normPoints1) * sol1));
% optional exercise version (comment for the original)
% disp("value of ||Mv|| for view1: " + norm(DLT_matrix(XmodelFiltered, normPoints1) * sol1));

% optional exercise version (comment for the original)
% disp("value of ||Mv|| for view1: " + norm(DLT_matrix(XmodelFiltered, normPoints1) * sol1));

sol2 = estimate_camera_DLT(Xmodel, normPoints2);
disp("smallest singular value of the solution for the point for view2: " + min(sol2));
disp("value of ||Mv|| for view2: " + norm(DLT_matrix(Xmodel, normPoints2) * sol2));
% in all 4 cases, the values seems to be close to 0

% use the 2 solutions to compute P1 and P2
P1_DLT = reshape(sol1(1:12) ,[4 3])';
P2_DLT = reshape(sol2(1:12) ,[4 3])';
% tranform the camera matrix to the original version
P1 = N1^(-1) * P1_DLT;
P2 = N2^(-1) * P2_DLT;
% bring Xmodel points set to homogeneus coordinates
XmodelNorm = [Xmodel; ones(1, size(Xmodel, 2))];

% optional exercise version (comment for the original)
% XmodelNormFiltered = [XmodelFiltered; ones(1, size(XmodelFiltered, 2))];

% projection of the 3D model point into the respective cameras
xModelProjP1 = pflat(P1 * XmodelNorm);
% optional exercise version (comment for the original)
% xModelProjP1 = pflat(P1 * XmodelNormFiltered);

xModelProjP2 = pflat(P2 * XmodelNorm);


% plot the projected point on the views
figure;
subplot(1, 2, 1);
imagesc(im1);
hold on;
plot(xModelProjP1(1, :), xModelProjP1(2, :),'w*');
title('view 1 with the 3D points projected into P1');
subplot(1, 2, 2);
imagesc(im2);
hold on;
plot(xModelProjP2(1, :), xModelProjP2(2, :),'w*');
title('view 2 with the 3D points projected into P2');
% the points appear to be close to each other, following
% the shape of the Rubrik cube


% for each camera, plot the 3D model visualizing
% camera center, principal axes and the 3D model points
figure;
subplot(1, 2, 1);
plot_camera(P1, 6);
hold on;
plot3 ([Xmodel(1, startind ); Xmodel(1 , endind )], [Xmodel(2, startind ); Xmodel(2 , endind )], [ Xmodel(3, startind ); Xmodel(3 , endind )], 'b-' );
title('3D model of view 1 and P1');
subplot(1, 2, 2);
plot_camera(P2, 8);
hold on;
plot3 ([Xmodel(1, startind ); Xmodel(1 , endind )], [Xmodel(2, startind ); Xmodel(2 , endind )], [ Xmodel(3, startind ); Xmodel(3 , endind )], 'r-' );
title('3D model of view 2 and P2');
% plots reasonable, since the camera matrix appear to point to the right
% side of the cube in the 3D version. The point to which the cameras
% are pointing to is their respective principle point



% compute the instrinsic parameter of the 2 cameras
[r1, q1] = rq(P1);
[r2, q2] = rq(P2);
K1 = r1;
% normalize the last column of K1 (the principal point)
K1 = K1 / K1(end, end);
K2 = r2;
% normalize the last column of K2 (the principal point)
K2 = K2 / K2(end, end);

% test: plot the principal points of each K on the respective views
figure;
subplot(1, 2, 1);
imagesc(im1);
hold on;
plot(K1(1, end), K1(2, end),'r*', "MarkerSize", 8);
text(K1(1, end), K1(2, end), "principal point", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'w');
subplot(1, 2, 2);
imagesc(im2);
hold on;
plot(K2(1, end), K2(2, end),'r*', "MarkerSize", 8);
text(K2(1, end), K2(2, end), "principal point", 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'Color', 'w');
% we know that K1 and K2 are the true inner paramters since:
% - plotting the normalized principal points to the respective image views,
%   the results appear to be reasonable
% no ambiguity becaus we know the inner parameter and the scale

test = inv(K1) * P1;
% with this you will obtain back the normalized 
% P1 from computed with DLT

save("estimatedCameras", "P1", "P2");
save("estimatedKs", "K1", "K2");


%% optional part
e_RMS_1_filtered = e_RMS(x{1}, xModelProjP1); 

% e_RMS without standardization (view1): 3.571624074460156
% e_RMS with normalization (view1): 3.571187330646256 (lower, which is right)
% e_RMS without normalization and fitered points (view1): 4.191299473674268
% e_RMS with normalization and fitered points (view1): 4.187240926018546

diff_RMS = abs(3.571624074460156 - 3.571187330646256);
diff_RMS_filtered_all = abs(4.191299473674268 - 4.187240926018546);
% difference in errors between all points eRMS --> 4.367438139003532e-04
% difference in errors between standardized points and filtered
%   standardized points eRMS --> 0.004058547655721

% conclusion: standardized points allows us to yield better numerical
% results for camera resectioning, especially if we have fewer 3D points 
% of the known object to perform DLT




