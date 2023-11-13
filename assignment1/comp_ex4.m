close all;
clear;

load('data/compEx4.mat');

[m, n] = size(K);
I = eye(m, n);
P1 = K * [I, [0; 0; 0]];

% plot image
im = imread('data/compEx4.jpg');
imagesc(im);
hold on;
plot ( corners (1 ,[1: end 1]) , corners (2 ,[1: end 1]) , 'r*-');
colormap gray;
axis equal;

% ensuring we have a calibrated camera, by normalizing the coordinate
% points and plotting them
hold off;
norm_corners = inv(K) * corners;
figure(2)
plot ( norm_corners (1 ,[1: end 1]) , norm_corners (2 ,[1: end 1]) , 'r*-');
axis ij
axis equal;
% even tho the difference in scale the origin of the image coordinate
% system is [-0.15, 0.34]

% compute the 3D points in the plane v that project onto the corner points.
% normalize the plane v
norm_v = pflat(v);
% compute the depth to obtain the corners projected into the plane v
s = [
  depth(norm_v, norm_corners(:, 1)),
  depth(norm_v, norm_corners(:, 2)),
  depth(norm_v, norm_corners(:, 3)),
  depth(norm_v, norm_corners(:, 4))
 ];
v_proj_corners = pflat([norm_corners; s.']);
[C1, principal_ax1] = camera_center_and_axis(P1);
figure(3)
plot_camera(P1, 1)
hold on;
text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
plot3( v_proj_corners(1 ,[1: end 1]) , v_proj_corners(2 ,[1: end 1]) , v_proj_corners(3 ,[1: end 1]), 'r*-');
% the plot looks reasonable, since the camera in the direction 
% of the principle axis points to the corner points projected
% into the plane v

% compute the new camera P2
C2 = [-2; 0; 0];
R = [
  cos(pi/6), 0, -sin(pi/6);
  0, 1, 0;
  sin(pi/6), 0, cos(pi/6);
];
T = inv((-R.')) * C2;
P2 = [R, T];
plot_camera(P2, 1);
% plot 
text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
axis equal;

% homography
H = (R - T * norm_v(1:3).');
virt_corners = pflat(H * norm_corners);


% plot the result from the homography in the previous 3d-plot
s_virt = [
  depth(norm_v, virt_corners(:, 1)),
  depth(norm_v, virt_corners(:, 2)),
  depth(norm_v, virt_corners(:, 3)),
  depth(norm_v, virt_corners(:, 4))
 ];
v_proj_virt_corners = pflat([virt_corners; s_virt.']);
plot3( v_proj_virt_corners(1 ,[1: end 1]) , v_proj_virt_corners(2 ,[1: end 1]) , v_proj_virt_corners(3 ,[1: end 1]), 'b*-');

% related 2d image of the points withb the applied homography
figure(4);
plot ( virt_corners (1 ,[1: end 1]) , virt_corners (2 ,[1: end 1]) , 'r*-');
axis equal;
% result match

% tranform img
Htot = K * H * K^-1;
tform = projtform2d(Htot);
figure(5);
[ im_new , RB ] = imwarp ( im , tform );
imshow ( im_new , RB );
hold on;
axis equal;
v_corn = pflat(corners.' * Htot);
plot(v_corn(1 ,[1: end 1]), v_corn(2 ,[1: end 1]) , 'r*-');




