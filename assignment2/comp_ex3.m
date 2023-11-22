close all;
clear;

% load images and data
im1 = imread("data/cube1.JPG");
im2 = imread("data/cube2.JPG");

[f1, d1] = vl_sift( single(rgb2gray(im1)), 'PeakThresh', 1);
[f2, d2] = vl_sift( single(rgb2gray(im2)), 'PeakThresh', 1);

figure;
subplot(1, 2, 1);
imagesc(im1);
hold on;
vl_plotframe(f1);
title('view1 with detected features');
subplot(1, 2, 2);
imagesc(im2);
hold on;
vl_plotframe(f2);
title('view1 with detected features');

[matches ,scores] = vl_ubcmatch(d1,d2);

% extract matching points
x1 = [f1(1,matches (1 ,:));f1(2,matches(1 ,:))]; 
x2 = [f2(1,matches (2 ,:));f2(2,matches(2 ,:))]; 

perm = randperm(size(matches,2)); 
figure; 
imagesc ([im1 im2]); 
hold on; 
plot([x1(1,perm (1:10)); x2(1,perm (1:10))+ size(im1 ,2)], [x1(2,perm (1:10)); x2(2,perm (1:10))] , '-');
hold off;

save("matchingPoints", "x1", "x2");