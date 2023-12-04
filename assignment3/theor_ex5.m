P1 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 0
];
F = [
    0 1 1;
    2 0 4;
    0 1 1
];
X1 = [0; 3; 1; 1];
X2 = [-1; 2; 0; 1];
C1 = null(P1);
e2 = null(F.');
e2x = [
    0 -e2(3) e2(2);
    e2(3) 0 -e2(1);
    -e2(2) e2(1) 0
];
P2 = [e2x * F, e2];

% check for X1
x1_P1 = P1 * X1;
x1_P2 = P2 * X1;
disp(x1_P2.' * F * x1_P1);

% check for X2
x2_P1 = P1 * X2;
x2_P2 = P2 * X2;
disp(x2_P2.' * F * x2_P1);

C2 = null(P2);
