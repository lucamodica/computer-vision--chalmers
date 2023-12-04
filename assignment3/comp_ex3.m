close all;
clear;

load("E.mat");
load("data/compEx1data.mat");
load("data/compEx2data.mat");
im2 = imread("data/kronan2.JPG");
im1 = imread("data/kronan1.JPG");

% compute the 4 cameras
cameras = extract_P_from_E(E);

% normalize the 2D points of the images
x1n = inv(K) * x{1};
x2n = inv(K) * x{2};

% triangulate points for each computed cameras
P1 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 0
];
X1t = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{1}));
X2t = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{2}));
X3t = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{3}));
X4t = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{4}));


% check for the points in front of both cameras, for each
% set of 3D points
x1tP1 = P1 * X1t;
x1tP2 = cameras{1} * X1t;

x2tP1 = P1 * X2t;
x2tP2 = cameras{2} * X2t;

x3tP1 = P1 * X3t;
x3tP2 = cameras{3} * X3t;

x4tP1 = P1 * X4t;
x4tP2 = cameras{4} * X4t;

x1tP1Front = x1tP1(3,:) > 0;
x1tP2Front = x1tP2(3,:) > 0;
disp("Number of points x1 in front of P1: " + sum(x1tP1Front));
disp("Number of points x1 in front of P2: " + sum(x1tP2Front));

x2tP1Front = x2tP1(3,:) > 0;
x2tP2Front = x2tP2(3,:) > 0;
disp("Number of points x2 in front of P1: " + sum(x2tP1Front));
disp("Number of points x2 in front of P2: " + sum(x2tP2Front));

x3tP1Front = x3tP1(3,:) > 0;
x3tP2Front = x3tP2(3,:) > 0;
disp("Number of points x3 in front of P1: " + sum(x3tP1Front));
disp("Number of points x3 in front of P2: " + sum(x3tP2Front));

x4tP1Front = x4tP1(3,:) > 0;
x4tP2Front = x4tP2(3,:) > 0;
disp("Number of points x4 in front of P1: " + sum(x4tP1Front));
disp("Number of points x4 in front of P2: " + sum(x4tP2Front));

% the second camera is the one with the highest number of
% point in front of both cameras
P2 = cameras{2};

P2u = K * P2;
P1u = K * P1;

% plot the image points and the projected 3D-points in the same figure
figure;
x2tP1u = pflat(P1u * X2t);
imagesc(im1);
hold on;
plot(x{1}(1, :), x{1}(2, :), 'r.');
plot(x2tP1u(1, :), x2tP1u(2, :), 'bO');
title("image points and the projected points from the selected camera (image1)");

figure;
x2tP2u = pflat(P2u * X2t);
imagesc(im2);
hold on;
plot(x{2}(1, :), x{2}(2, :), 'r.');
plot(x2tP2u(1, :), x2tP2u(2, :), 'bO');
title("image points and the projected points from the selected camera (image2)");

% overall, the error looks small for the alignment between the points
% of the images and the projection of the points retrieved from the
% computed camera

% 3D plot
figure;
plot3(X2t(1, :), X2t(2, :), X2t(3, :), 'b.');
hold on;
[C1, principal_ax1] = camera_center_and_axis(P1u);
plot_camera(P1u, 3);
text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
[C2, principal_ax2] = camera_center_and_axis(P2u);
plot_camera(P2u, 3);
text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
title("3D reconstruction of the building with the 2 cameras");

% the 3D reconstruction looks like I expected it to, reflecting the
% building in the 2D images, with the 2 cameras pointing in the corrected
% directions

