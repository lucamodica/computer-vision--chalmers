%% project init
% clear environment
close all;
clc;
clear;

% add all the function in the utls folder to the working path
addpath utils/;
addpath data/;

% load vlfeat library (replace the parameter with your 
% path to vl_setup.m file in vlfeat library folder)
run("/home/lucamodica/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup.m");

% setting a fixed random seed (especially for debugging purposes)
% rng(10);
    
% retrieve and return information of the selected dataset
% (replace the get_dataset_info parameter with the number
% of the dataset)
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(5);
    
% save the images in a cell struct
imgs = cellfun(@(name) imread(name), img_names, 'UniformOutput', false);


%% test
% retrieve and save points using SIFT and the pair of images
[f1 d1] = vl_sift( single(rgb2gray(imgs{init_pair(1)})) ); 
[f2 d2] = vl_sift( single(rgb2gray(imgs{init_pair(2)})) ); 
matches = vl_ubcmatch(d1,d2);
xa = f1(1:2, matches (1 ,:)); 
xb = f2(1:2, matches (2 ,:));
x1 = [xa; ones(1, length(xa))];
x2 = [xb; ones(1, length(xb))];
save("sift_points", "x1", "x2", "matches");

% load already computed SIFT points (used 
% especially for debugging and accelerate
% the process)
load("sift_points.mat");

% estimating best R and T
[R_best, T_best] = estimate_R_T_robust(K, inv(K) * x1, inv(K) * x2, pixel_threshold);


