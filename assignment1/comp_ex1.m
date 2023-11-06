load('./data/compEx1.mat')

% pflatting x2D and x3D
x2Dp = pflat(x2D);
x3Dp = pflat(x3D);

% plot x2Dp
figure;
plot_points_2D(x2Dp);
axis equal;

% plot x3Dp
figure;
plot_points_3D(x3Dp);
axis equal;
