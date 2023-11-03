% ### EX2 ###
l1 = [-1; 1; 1];
l2 = [6; 3; 1];

% compute the intersection between l1 and l2
intersL1L2 = cross(l1, l2);

% homogeneus coordinates of the intersection in P^2,
% also to get the related point in R^2
h_intersL1L2 = pflat(intersL1L2);

l3 = [-3; 0; 1];
l4 = [5; 0; 4];
intersL3L4 = cross(l3, l4);
h_intersL3L4 = pflat(intersL3L4);
% the intersection of the point in P^2 tends to infinity, since the lines
% are parallel to each other. That is the geometric interpretation in R^2

x1 = [-1; 1];
x2 = [6; 3];
x1_h = [x1; 1];
x2_h = [x2; 1];
l = cross(x1_h, x2_h);
% it's the de-normalization of the first cross-product

% ### EX3 ###
M = [6, 3, 1; -1, 1, 1];
% verifying the intersection l1-l2 is in the null-space
check_intersL1l2 = M * intersL1L2; % = 0, so intersL1L2 is in the null space of M

% computing the null space and normalizing it gives you 
% [0.222222222222222;-0.777777777777778;1].
% The point obtained is also in null(M). In general, since the
% coordinates are homogeneus, there many points in P^2 that are
% also in that null space, since, for a scale factor lamba, we have:
% x = lamba * y, x,y \in P^2
sol = null(M);
pflat(sol);






