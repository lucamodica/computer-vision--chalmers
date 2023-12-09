close all;
clear;

load("data/compEx2data.mat");
im1 = imread("data/fountain1.png");
im2 = imread("data/fountain2.png");

% display the images
figure;
subplot(1, 2, 1);
imagesc(im1);
subplot(1, 2, 2);
imagesc(im2);

% [fA dA] = vl_sift( single(rgb2gray(im1))); 
% [fB dB] = vl_sift( single(rgb2gray(im2))); 
% matches = vl_ubcmatch(dA,dB);
% xA = fA(1:2, matches (1 ,:)); 
% xB = fB(1:2, matches (2 ,:)); 
% save("sift_points", "xA", "xB", "matches");

load("sift_points.mat");
% f_m1 = 39561
% f_m2 = 38775
% 2604 point matches for both im1 and im2

% estimate E using RANSAC
x1n = inv(K) * [xA; ones(1, length(xA))];
x2n = inv(K) * [xB; ones(1, length(xB))];
[E, inliersIdxs] = estimate_E_robust(K, x1n, x2n);
disp(sum(inliersIdxs));

% estimate P2
P1 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 0
];

% comoute best P2 and its related 3D points
[P2, X] = find_best_P2(E, x1n, x2n, P1);

P2u = K * P2;
P1u = K * P1;

% plot the image points and the projected 3D-points in the same figure
figure;
xtP1u = pflat(P1u * X);
imagesc(im1);
hold on;
plot(xA(1, :), xA(2, :), 'r.');
plot(xtP1u(1, :), xtP1u(2, :), 'bO');
title("image points and the projected points from the selected camera (image1)");

figure;
xtP2u = pflat(P2u * X);
imagesc(im2);
hold on;
plot(xB(1, :), xB(2, :), 'r.');
plot(xtP2u(1, :), xtP2u(2, :), 'bO');
title("image points and the projected points from the selected camera (image2)");

% overall, the error looks small for the alignment between the points
% of the images and the projection of the points retrieved from the
% computed camera

% 3D plot
figure;
plot3(X(1, :), X(2, :), X(3, :), 'b.');
hold on;
[C1, principal_ax1] = camera_center_and_axis(P1u);
plot_camera(P1u, 3);
text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
[C2, principal_ax2] = camera_center_and_axis(P2u);
plot_camera(P2u, 3);
text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
title("3D reconstruction of the building with the 2 cameras");




