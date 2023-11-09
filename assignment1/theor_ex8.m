P1 = [eye(3, 3), [0; 0; 0]];

syms s x1 x2 u1 u2 u3 u4

U = [u1; u2; u3; u4];
x = [x1; x2; 1];
U_s = [x.', s].';

x_proj = P1 * U;
% since we obtain a generic pint in P^2, for any s we can have
% U \tilde (x s)
U_s_proj = P1 * U_s;

syms pi1 pi2 pi3
PI = [pi1; pi2; pi3; 1];
pi = [pi1; pi2; pi3];
% values of s to make U(s) belongs to a plane
eq = PI.' * U_s;
% we get: pi3 + s + pi1*x1 + pi2*x2
% rearranign the values we obtain s = pi1*x1 + pi2*x2 + pi3
% PI.' * [x.', -(pi3 + pi1*x1 + pi2 * x2)].'
PI.' * [x.', - pi.'*x].'
% we obtain 0 -> :)

syms r11 r12 r13 r21 r22 r23 r31 r32 r33 t1 t2 t3
R = [
    r11, r12, r13;
    r21, r22, r23;
    r31, r32, r33
];
t = [t1; t2; t3];
P2 = [R, t];
pi = [pi1; pi2; pi3];
H  = (R - t * pi.');