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
xProj = pflat(P{1, 1} * X);
im = imread("data/" + imfiles{1}); %Reads the imagefile with name in imfiles{1}

figure(2);
imagesc(im);
hold on;
visible = isfinite(x{1}(1 ,:)); 
plot(x{1}(1, visible), x{1}(2, visible),'*'); %Plots a '*' at each point coordinate 
plot(xProj(1,visible), xProj(2,visible),'ro'); % Plots a red 'o' at each visible point in xproj 
legend('2D points for image 1', 'Projected points');
disp("Number of points detected into the image: " + sum(visible));
% we can notice from the plot that the projection and the actual
% points are close

% projcting X into the 2 projetive transformations and
% creating 2 other camera sets in the same way
T1 = [
    1, 0, 0, 0;
    0, 3, 0, 0;
    0, 0, 1, 0;
    1/8, 1/8, 0, 1;
];
T2 = [
    1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, 0;
    1/16, 1/16, 0, 1;
];
XT1 = pflat(T1 * X);
XT2 = pflat(T2 * X);
PT1 = P;
PT2 = P;
for i = 1:length(P)
    PT1{1, i} = P{1, i} * T1^(-1);
    PT2{1, i} = P{1, i} * T2^(-1);
end

% for each projection Ti, plot the new point projection
% and the related new cameras
figure(3);
plot_points_3D(XT1, 3);
axis equal;
hold on;
plotcams(PT1);

figure(4);
plot_points_3D(XT2, 3);
axis equal;
hold on;
plotcams(PT2);

% the 3D points were tranformed with the projective tranformations 
% T1 and T2, which added in general translations and 
% a different scale compared to the original 3D points with the
% original cameras.
% T1X -> not reasonable due to distortion
% T2X -> reaasonable ralted to real world coordinates


% with the projected 3D points and cameras from
% the previous part, we will plot them into an
% image using the related camera, alongside its
% related image points
figure(5);
project_and_plot(PT1{1, 1}, XT1, im, x{1})
legend('2D points for image 1', 'Projected points with T1');

figure(6);
project_and_plot(PT2{1, 1}, XT2, im, x{1})
legend('2D points for image 1', 'Projected points with T2');

% for both the new reconstructions, the projections 
% and the image points align as well as the the original
% 3D points projected with the original cameras. This is
% due to projective ambiguity: for the camera of the choosen
% image we don't know the inner parameter K, thus the camera
% is unclalibrated




