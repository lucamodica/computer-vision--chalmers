im = imread( './data/compEx2.jpg'); %Loads the image compEx2.jpg
load('./data/compEx2.mat')

imagesc(im)
colormap gray

hold on

% This resulting vector of a cross product between 2 points (a, b, c) 
% actually represents a line in the projective plane in homogeneous 
% coordinates, where a, b, and c are the coefficients of the line 
% equation: ax + by + c = 0.
l1 = pflat(cross(p1(:, 1), p1(:, 2)));
l2 = pflat(cross(p2(:, 1), p2(:, 2)));
l3 = pflat(cross(p3(:, 1), p3(:, 2)));

rital(l1, '-g')
rital(l2, '-b')
rital(l3, '-w')

plot_points_2D(pflat(p1), 'b')
plot_points_2D(pflat(p2), 'w')
plot_points_2D(pflat(p3), 'g')

% since the line vectors are independent from
% each other, the same lines are not parallel
% in a 3D space. Another way to confirm is that
% the ratios of the component-wise value (b1x1/b2x2, 
% ...., = constant) are not the same.
check_lines_parallel_in_3D([l1, l2, l3]);

% intersection between l2 and l3
intersL2L3 = pflat(null([transpose(l2); transpose(l3)]));
plot_points_2D(intersL2L3, 'r');

% compute distance between intersL2L3 and l1
d = point_line_distance_2D(intersL2L3, l1);
disp('distance between the intersection of l2 l3, and l1: ')
disp(d)

% check the null space for each pair of lines and for
% all of them
nullL1L2 = pflat(null([transpose(l1); transpose(l2)]));
nullL1L3 = pflat(null([transpose(l1); transpose(l3)]));
nullL2L3 = pflat(null([transpose(l2); transpose(l3)]));
nullAll = pflat(null([transpose(l1); transpose(l2); transpose(l3)]));
