close all;
clear;

% load images and data
im1 = imread("data/cube1.JPG");
im2 = imread("data/cube2.JPG");
load("estimatedCameras.mat");
load("estimatedKs.mat");
load("matchingPoints.mat");
load("data/compEx3data.mat");

% triangulate points for each view
Xpoints = triangulate_3D_point_DLT(x1, x2, P1, P2);

% project the 3D points
Xpoints1Proj = pflat(P1 * Xpoints);
Xpoints2Proj = pflat(P2 * Xpoints);

% project the SIFT and computed points into the related views
figure;
subplot(1, 2, 1);
imagesc(im1);
hold on;
plot(x1(1, :), x1(2, :),'gO');
plot(Xpoints1Proj(1, :), Xpoints1Proj(2, :),'r.');
title('view1 with the projection of the computed and SIFT feature points');
subplot(1, 2, 2);
imagesc(im2);
hold on;
plot(x2(1, :), x2(2, :),'gO');
plot(Xpoints2Proj(1, :), Xpoints2Proj(2, :),'r.');
title('view2 with the projection of the computed and SIFT feature points');
% the results seem reasonable since the projected points aligned with
% SIFT ones


% perform the same comparison but with 2D points and cameras normalized
P1norm = K1^(-1) * P1;  
P2norm = K2^(-1) * P2;
x1norm = K1^(-1) * [x1; ones(1, length(x1))];
x2norm = K2^(-1) * [x2; ones(1, length(x2))];

% triangulate points for each view
Xpointsnorm = triangulate_3D_point_DLT(x1norm, x2norm, P1norm, P2norm);

% project the 3D points
Xpoints1ProjNorm = pflat(P1 * Xpointsnorm);
Xpoints2ProjNorm = pflat(P2 * Xpointsnorm);

figure;
subplot(1, 2, 1);
imagesc(im1);
hold on;
plot(x1(1, :), x1(2, :),'gO');
plot(Xpoints1ProjNorm(1, :), Xpoints1ProjNorm(2, :),'r.');
title('view1 with the normalized projection of the computed points and SIFT feature points');
subplot(1, 2, 2);
imagesc(im2);
hold on;
plot(x2(1, :), x2(2, :),'gO');
plot(Xpoints2ProjNorm(1, :), Xpoints2ProjNorm(2, :),'r.');
title('view2 with the normalized projection of the computed points and SIFT feature points');

% compute the means squared error for both the first and second
% version of the points
e_x1 = e_RMS([x1; ones(1, length(x1))], Xpoints1Proj);
e_x2 = e_RMS([x2; ones(1, length(x2))], Xpoints2Proj);
e_norm_x1 = e_RMS([x1; ones(1, length(x1))], Xpoints1ProjNorm);
e_norm_x2 = e_RMS(x2norm, Xpoints2ProjNorm);
diff_e_x1 = e_x1 - e_norm_x1;
% with this we should compare the original version with normalized one
% ask why the normalized error is higher TO THE TA




%Finds the points with reprojection error less than 3 pixels in both images
good_points = (sqrt(sum((x1-Xpoints1Proj(1:2, :)).^2)) < 3 & sqrt(sum((x2-Xpoints2Proj(1:2, :)).^2)) < 3);

%Removes points that are not good enough from the SIFT points
Xgood = pflat(Xpointsnorm(:, good_points));

% plot everything
[C1, p_axis1] = camera_center_and_axis(P1);
[C2, p_axis2] = camera_center_and_axis(P2);
figure;
plot_camera(P1, 7);
hold on;
plot_camera(P2, 7);
plot3 ([Xmodel(1, startind ); Xmodel(1 , endind )], [Xmodel(2, startind ); Xmodel(2 , endind )], [ Xmodel(3, startind ); Xmodel(3 , endind )], 'b-' );
plot3(Xgood(1, :), Xgood(2, :), Xgood(3, :), ' . ', 'MarkerSize', 4, 'Color', 'black');
text(C1(1), C1(2), C1(3), 'P1', 'FontSize', 12, 'HorizontalAlignment', 'right');
text(C2(1), C2(2), C2(3), 'P2', 'FontSize', 12, 'HorizontalAlignment', 'right');
title('3D model and the 3D good points, with P1 and P2');







