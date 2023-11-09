% Close all figure windows and clear the variables
clear;
close all;

% Load and plot the images
figure("Name", "images");
image1 = imread('data/compEx3im1.jpg');
image2 = imread('data/compEx3im2.jpg');
subplot(1, 2, 1);
imagesc(image1);
subplot(1, 2, 2);
imagesc(image2);
colormap gray;

% load the points
load('data/compEx3.mat');

% retrieve camera center and principle axis
% from the 2 camera matrices
[C1, p_axis1] = camera_center_and_axis(P1);
[C2, p_axis2] = camera_center_and_axis(P2);

% plot the principal axis starting from the camera center
figure(3);
plot_camera(P1, 2);
text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
hold on;
plot_camera(P2, 5);

% Plot the 3D-points in U and the camera centers in the same 3D plot
figure(4)
plot_points_3D(pflat(U), 2);
grid on;
hold on;
plot_camera(P1, 1);
plot_camera(P2, 6);
text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');

% Project the points in U into the cameras P1 and P2 and plot the result 
% in the same plots as the images
figure("Name", "images with U points");
subplot(1, 2, 1);
imagesc(image1);
hold on;
projUP1 = pflat(P1 * U);
plot(projUP1(1, :), projUP1(2, :), '.', 'MarkerSize', 3);

subplot(1, 2, 2);
imagesc(image2);
hold on;
projUP2 = pflat(P2 * U);
plot(projUP2(1, :), projUP2(2, :), '.', 'MarkerSize', 3);

colormap gray;

% the result of the projections of the points in U seem reasonable,
% since they align with the actual image points.
