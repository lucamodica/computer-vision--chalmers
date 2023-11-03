x1 = [1; 2; 1; 1];
x2 = [1; 1; 3; 1];
x3 = [2; 1; -1; 1];

P = [
    1, 0, 0, 0;
    0, 1, 0, 0;
    0, 0, 1, -1
];

x1Proj = P * x1;
% x1Proj, following the pinhole camera model, is in
% quotient set x1Proj ~ K(R | T)x1 = x1Proj ~ Px1

% compute the camera center.
% C is computed by computing the null-space of the matrix
% P; in other words, the camera center is the 3D-coordinate
% point "x" for which: P * x = 0.
C = pflat(null(P));