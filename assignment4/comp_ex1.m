close all;
clear;

load("data/compEx1data.mat");
im1 = imread("data/round_church1.jpg");
im2 = imread("data/round_church2.jpg");

x1n = inv(K) * x{1};
x2n = inv(K) * x{2};

% compute E and F
Ee = reshape(estimate_F_DLT(x1n, x2n), [3 3]);
E = enforce_essential(Ee);
F = convert_E_to_F(E, K, K);

% comoute the epipolar lines
l2 = F * x{1};
l1 = F.' * x{2};

% compute epipolar error
dl2 = compute_epipolar_errors(F, x{1}, x{2});
dl1 = compute_epipolar_errors(F.', x{2}, x{1});
m = length(x{1});
e_rms = sqrt((1/(2*m)) * (sum(dl1.^2) + sum(dl2.^2)));

% plot histogram of the distances
figure;
subplot(1, 2, 1);
histogram(dl1, 100);
xlabel('epipolar errors');  
ylabel('number of points');
title("Epipolar errors histogram (dl1) (without RANSAC)");
subplot(1, 2, 2);
histogram(dl2, 100);
xlabel('epipolar errors');
ylabel('number of points');
title("Epipolar errors histogram (dl2) (without RANSAC)");

% 20 random points (and epipolar lines) on the first image
idxs = randperm(size(x{1}, 2), 20);
samples_x1 = x{1}(:, idxs);
figure;
imagesc(im1);
hold on;
rital(l1(:, idxs), "b");
plot(samples_x1(1, :), samples_x1(2, :), '.', 'MarkerSize', 9, 'Color', "r");
title("Points sample with the epipolar lines (first image)");
% 20 random points (and epipolar lines) on the second image
samples_x2 = x{2}(:, idxs);
figure;
imagesc(im2);
hold on;
rital(l2(:, idxs), "b");
plot(samples_x2(1, :), samples_x2(2, :), '.', 'MarkerSize', 9, 'Color', "r");
title("Points sample with the epipolar lines (second image)");
% the plots look reasonable: with many different 
% random sample of 20 points, several points are
% quite distant to the related epipolar lines due
% due to the precence of outliers in the original
% image point set, used to estimate E. THis, for
% both the images



% robustly estimate E using RANSAC, and check the results 
% with the same experiments / plots as before
[E, inliersIdxs] = estimate_E_robust(K, x1n, x2n);
disp("Number of inliers found: " + sum(inliersIdxs));
F = convert_E_to_F(E, K, K);

% compute the epipolar lines
l2 = F * x{1};
l1 = F.' * x{2};

% compute epipolar error and histogram (with all the points)
dl2 = compute_epipolar_errors(F, x{1}, x{2});
dl1 = compute_epipolar_errors(F.', x{2}, x{1});
m = length(x{1});
e_rms_RANSAC = sqrt((1/(2*m)) * (sum(dl1.^2) + sum(dl2.^2)));
figure;
subplot(1, 2, 1);
histogram(dl1, 100);
xlabel('epipolar errors');  
ylabel('number of points');
title("Epipolar errors histogram (dl1) (with RANSAC and all the points)");
subplot(1, 2, 2);
histogram(dl2, 100);
xlabel('epipolar errors');
ylabel('number of points');
title("Epipolar errors histogram (dl2) (with RANSAC and all the points)");

% compute epipolar error and histogram (with all the points)
dl2 = compute_epipolar_errors(F, x{1}(:, inliersIdxs), x{2}(:, inliersIdxs));
dl1 = compute_epipolar_errors(F.', x{2}(:, inliersIdxs), x{1}(:, inliersIdxs));
m = length(x{1});
e_rms_RANSAC_inliers = sqrt((1/(2*m)) * (sum(dl1.^2) + sum(dl2.^2)));
figure;
subplot(1, 2, 1);
histogram(dl1, 100);
xlabel('epipolar errors');  
ylabel('number of points');
title("Epipolar errors histogram (dl1) (with RANSAC and only inliers)");
subplot(1, 2, 2);
histogram(dl2, 100);
xlabel('epipolar errors');
ylabel('number of points');
title("Epipolar errors histogram (dl2) (with RANSAC and only inliers)");


% sample 20 random points of the first image
x1i = x{1}(:, inliersIdxs);
l1i = l1(:, inliersIdxs);
idxs = randperm(size(x1i, 2), 20);
samples_x1 = x1i(:, idxs);
figure;
imagesc(im1);
hold on;
rital(l1i(:, idxs), "b");
plot(samples_x1(1, :), samples_x1(2, :), '.', 'MarkerSize', 9, 'Color', "r");
title("Points sample (among inliers) with the epipolar lines (image 1)");


% sample 20 random points of the second image
x2i = x{2}(:, inliersIdxs);
l2i = l2(:, inliersIdxs);
idxs = randperm(size(x2i, 2), 20);
samples_x2 = x2i(:, idxs);
figure;
imagesc(im1);
hold on;
rital(l2i(:, idxs), "b");
plot(samples_x2(1, :), samples_x2(2, :), '.', 'MarkerSize', 9, 'Color', "r");
title("Points sample (among inliers) with the epipolar lines (image 2)");

