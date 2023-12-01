close all;
clear;

load("data/compEx1data.mat");
im1 = imread("data/kronan1.JPG");
im2 = imread("data/kronan2.JPG");

N1 = standardization_mat(x{1});
N2 = standardization_mat(x{2});
% N1 = eye(3, 3);
% N2 = eye(3, 3);

x1n = N1 * x{1};
x2n = N2 * x{2};


Fn = reshape(estimate_F_DLT(x1n, x2n), [3 3]);

% ||Mv|| close to 0
M = DLT_matrix_for_F(x1n, x2n);
v = estimate_F_DLT(x1n, x2n);
disp("Check value of ||Mv||: " + norm(M * v));

% det(F) basically 0
disp("Determinant of F: " + det(Fn));

% force det(F) to be 0
Fn = enforce_fundamental(Fn);
disp("Determinant of forced F: " + det(Fn));

% make sure that the epipolar constraints 
% are roughly fufilled, from a plot
figure;
plot(diag(x2n'*Fn*x1n));

% Compute the un-normalized fundamental matrix F
F = N2.' * Fn * N1;
F = F ./ F(end);

% compute the epipolar lines
l = F*x{1};
% Makes sure that the line has a unit normal 
% (makes the distance formula easier) 
l = l./sqrt(repmat(l(1,:).^2 + l(2 ,:).^2 ,[3 1]));

% sample 20 random points of the second image
idxs = randperm(size(x{2}, 2), 20);
samples_x2 = x{2}(:, idxs);

% plot the points sample with the epipolar lines
figure;
imagesc(im2);
hold on;
rital(l(:, idxs), "b");
plot(samples_x2(1, :), samples_x2(2, :), '.', 'MarkerSize', 9, 'Color', "r");
% the points are close to the corresponding epipolar lines.

% Computes all the the distances between the points 
% and there corresponding lines , and plots in a histogram
figure;
histogram(compute_epipolar_errors(F, x{1}, x{2}), 100);
xlabel('epipolar errors');
ylabel('number of points');

% mean distance (aka mean epipolar errors)
disp("mean distance (aka mean epipolar errors): " + mean(compute_epipolar_errors(F, x{1}, x{2})));

