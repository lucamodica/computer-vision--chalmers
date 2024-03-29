x1 = [1; 2; 1; 1];
x2 = [1; 1; 3; 1];
x3 = [2; 1; -1; 1];

P = [
    1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, -1
];
T = P(:, 4);

x1Proj = P * x1;
x1ProjP = pflat(x1Proj);
% x1 is not in the image plane, thus not visible to the camera.
% it's an infinite point in the direction (1, 2).

x2Proj = pflat(x2Proj);
x3Proj = pflat(x3Proj);

% compute the camera center.
% C is computed by computing the null-space of the matrix
% P; in other words, the camera center is the 3D-coordinate
% point "x" for which: P * x = 0.
C = pflat(null(P));

Ctest = P(1:3, 1:3)^(-1) * -T; 

% the principle axis corresponds with the first 3 components
% of the last row, which is (0, 0, 1)
p_axis = pflat(P(3 ,1:3).');