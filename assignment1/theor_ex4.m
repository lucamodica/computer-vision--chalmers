H = [1, 1, 0; 0, 1, 1; 0, -1, 1];

x1 = [1; 0; 1];
x2 = [0; 1; 1];

% compute y1 ˜ Hx_1  and y2 ˜ Hx_2. for this, we will
% define a lambda symbol to represent
syms lamda
y1 = lamda * H * x1;
y2 = lamda * H * x2;

l1 = pflat(cross(x1, x2));
l2 = pflat(cross(y1, y2)); % [-2, 1, 1]

to_comp_l2 = transpose(inv(H)) * l1; % [-1, 1/2, 1/2]
disp(l2 == pflat(to_comp_l2))
% the lines are the same, thus linerly dependent. We
% can confirm since the lines point to same direction and,
% if normalized, those are equal.
