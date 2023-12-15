close all;
clear;

load("data/compEx2data.mat");
im1 = imread("data/fountain1.png");
im2 = imread("data/fountain2.png");

% display the images
figure;
subplot(1, 2, 1);
imagesc(im1);
subplot(1, 2, 2);
imagesc(im2);

% [fA dA] = vl_sift( single(rgb2gray(im1))); 
% [fB dB] = vl_sift( single(rgb2gray(im2))); 
% matches = vl_ubcmatch(dA,dB);
% xA = fA(1:2, matches (1 ,:)); 
% xB = fB(1:2, matches (2 ,:)); 
% save("sift_points", "xA", "xB", "matches");

load("sift_points.mat");
% f_m1 = 39561
% f_m2 = 38775
% 2604 point matches for both im1 and im2

% estimate E using RANSAC
x1n = inv(K) * [xA; ones(1, length(xA))];
x2n = inv(K) * [xB; ones(1, length(xB))];
[E, inliersIdxs] = estimate_E_robust(K, x1n, x2n);
disp(sum(inliersIdxs));

% estimate P2
P1 = [
    1 0 0 0;
    0 1 0 0;
    0 0 1 0
];

% comoute best P2 and its related 3D points
[P2, X] = find_best_P2(E, x1n, x2n, P1, K, inliersIdxs);

P2u = K * P2;
P1u = K * P1;




