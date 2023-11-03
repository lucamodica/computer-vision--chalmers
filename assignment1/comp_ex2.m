im = imread( './data/compEx2.jpg'); %Loads the image compEx2.jpg
load('./data/compEx2.mat')

imagesc(im)
colormap gray

hold on

plot_points_2D(pflat(p1))
plot_points_2D(pflat(p2))
plot_points_2D(pflat(p3))

l1 = pflat(cross(p1(:, 1), p1(:, 2)));
l2 = pflat(cross(p2(:, 1), p2(:, 2)));
l3 = pflat(cross(p3(:, 1), p3(:, 2)));
check_lines_parallel_in_3D([l1, l2, l3]);

rital(l1)
rital(l2)
rital(l3)

% since the line vectors are independent from
% each other, the same lines are not parallel
% in a 3D space. Another way to confirm is that
% the ratio of the component-wise value (b1x1/b2x2, ....,
% = constant) are not the same.

% intersection between l2 and l3
intersL2L3 = cross(l2, l3);
plot_points_2D(pflat(intersL2L3), 'w');

% compute distance between intersL2L3 and l1
d = point_line_distance_2D(pflat(intersL2L3), pflat(l1));
disp('distance between the intersection of l2 l3, and l1')
disp(d)
% relatively, the distance is close to 0 for non-parallelism of the lines