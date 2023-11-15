close all;
clear;

load('data/compEx1data.mat');

% plot 3D points of the recontruction and the different 9 cameras
figure(1);
plot_points_3D(pflat(X), 3.2);
axis equal;
hold on;
plotcams(P);
% the physical properties (such as the relative heights of each of the two walls, the angle in 
% the corner, and the relation between the width, height, and depth dimensions) look realistic in the 
% reconstruction.

% choosing the first image, project the 3D point in the related
% camera and plot them
xproj = pflat(P{1, 1} * X);
im = imread("data/" + imfiles{1}); %Reads the imagefile with name in imfiles{1}

figure(2);
imagesc(im);
hold on;
visible = isfinite(x{1}(1 ,:)); 
plot(x{1}(1, visible), x{1}(2, visible),'*'); %Plots a '*' at each point coordinate 
plot(xproj(1,visible), xproj(2,visible),'ro'); % Plots a red 'o' at each visible point in xproj 
legend('2D points for image 1', 'Projected points');
disp("Number of points detected into the image: " + sum(visible));
% we can notice from the plot that the projection and the actual
% points are close



