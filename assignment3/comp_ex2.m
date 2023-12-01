close all;
clear;

load("data/compEx2data.mat");
load("data/compEx1data.mat");

im2 = imread("data/kronan2.JPG");

x1n = inv(K) * x{1};
x2n = inv(K) * x{2};

% estimate the essential matrix
En = reshape(estimate_F_DLT(x1n, x2n), [3 3]);

% ||Mv|| close to 0
M = DLT_matrix_for_F(x1n, x2n);
v = estimate_F_DLT(x1n, x2n);
disp("Check value of ||Mv||: " + norm(M * v));

% det(F) basically 0
disp("Determinant of E: " + det(En));

% force det(F) to be 0
E = enforce_essential(En);
disp("Determinant of forced E: " + det(E));

% make sure that the epipolar constraints 
% are roughly fufilled, from a plot
figure;
plot(diag(x2n'*E*x1n));

% comoute F and the epipolar lines
F = convert_E_to_F(E, K, K);
l = F * x{1};
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
% compared to the computer exercise 1, we have a much bigger mean distance,
% thus a much bigger error

% save the essential matrix E for the computer exercise 3
save("E", "E");

