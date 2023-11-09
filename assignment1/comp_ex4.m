close;

load('data/compEx4.mat')

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

% the origin of the camera center is the bottom left of the image ([0, 968])

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
U = [norm_corners; [1, 1, 1, 1]];

