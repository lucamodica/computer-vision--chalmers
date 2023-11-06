% ### EX2 ###
l1 = [-1; 1; 1];
l2 = [6; 3; 1];

% compute the intersection between l1 and l2
intersL1L2 = cross(l1, l2);
test = null([transpose(l1); transpose(l2)]);
n_test = pflat(test);

% normalized coordinates of the intersection in P^2,
% also to get the related point in R^2
n_intersL1L2 = pflat(intersL1L2);

l3 = [-3; 0; 1];
l4 = [5; 0; 4];
intersL3L4 = cross(l3, l4);
n_intersL3L4 = pflat(intersL3L4);
nullL3L4 = null([transpose(l3); transpose(l4)]);
% the intersection of the point in P^2 tends to infinity, since the lines
% are parallel to each other. That is the geometric interpretation in R^2

x1 = [-1; 1];
x2 = [6; 3];
x1_h = [x1; 1];
x2_h = [x2; 1];
l = cross(x1_h, x2_h);
% it's the de-normalizaotion of the first cross-product

% ### EX3 ###
M = [6, 3, 1; -1, 1, 1];
% verifying the intersection l1-l2 is in the null-space
check_intersL1l2 = M * intersL1L2; % = 0, so intersL1L2 is in the null space of M


sol = null(M);
pflat(sol);






