F = [
    0 0 3;
    0 0 -6;
    6 3 -1
];

P1 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 0
];

P2 = [
    0 1 1 2;
    3 2 0 1;
    0 0 3 0
];

C1 = pflat(null(P1));
C2 = pflat(null(P2));

e1 = P1 * C2;
e2 = P2 * C1;

disp("det(F): " + det(F));
