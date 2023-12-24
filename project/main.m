%% project init
% clear environment
close all;
clc;
clear;

% debugging flag
debug_mode = false;

% add all the function in the utls folder to the working path
addpath utils/;
addpath data/;

% load vlfeat library (replace the parameter with your 
% path to vl_setup.m file in vlfeat library folder)
run("/home/lucamodica/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup.m");

% setting a fixed random seed (especially for debugging purposes)
rng(42);
    
% retrieve and return information of the selected dataset
% (replace the get_dataset_info parameter with the number
% of the dataset)
dataset = 9;
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(dataset);
    
% save the images in a cell struct
imgs = cellfun(@(name) imread(name), img_names, 'UniformOutput', false);

% check if a file with the absolute rotations and relative orientation 
% already exists, and in case load them (for debugging purposes)
if debug_mode && exist("abs_rotation_" + dataset + ".mat", "file") ...
    && exist("rel_orientation_" + dataset + ".mat", "file") ...

    load("rel_orientation_" + dataset + ".mat");
    load("abs_rotation_" + dataset + ".mat");
    disp("Already computed absolute rotations found and loaded!");
else
    % Calculate relative orientations between images (i) and (i+1)
    disp("Computing relative orientations between images (i) and (i+1)...");
    relRs = cell(1, length(imgs)-1);
    relTs = cell(1, length(imgs)-1);
    for i = 1:length(imgs)-1
        % retrieve and save points using SIFT and the pair of images
        [f1 d1] = vl_sift( single(rgb2gray(imgs{i}))); 
        [f2 d2] = vl_sift( single(rgb2gray(imgs{i+1}))); 
        matches = vl_ubcmatch(d1,d2);
        xa = f1(1:2, matches (1 ,:)); 
        xb = f2(1:2, matches (2 ,:));
        x1 = [xa; ones(1, length(xa))];
        x2 = [xb; ones(1, length(xb))];
        
        % estimating best R and T of the the P2 camera
        % P_{i, 2} = (R_{i, i+1}, T_{i, i+1})
        [relRs{i}, relTs{i}, ~, X] = estimate_R_T_robust(K, inv(K) * x1, inv(K) * x2, pixel_threshold);
        X = filter_far_3d_points(X);
    
        % plot for checking the correctness of the current 
        % relative pose (debug mode)
        % if debug_mode
            P1 = [
                1 0 0 0;
                0 1 0 0;
                0 0 1 0
            ];
            P2 = [relRs{i}, relTs{i}];
            P2u = K * P2;
            P1u = K * P1;
            figure;
            plot3(X(1, :), X(2, :), X(3, :), 'b.');
            hold on;
            [C1, ~] = camera_center_and_axis(P1u);
            plot_camera(P1, 1);
            text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
            [C2, ~] = camera_center_and_axis(P2u);
            plot_camera(P2, 1);
            text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
            disp("Relative oriantation between camera " + i + " and " + num2str(i+1) + " computed!");
        % end
    end
    save("rel_orientation_" + dataset, "relRs", "relTs");
    disp("done!");

    % Upgrade to absolute rotations R_i
    % (we used the rotation chain method
    % to do that)
    disp("Upgrade to absolute rotations R_i");
    absRs = cell(1, length(imgs));
    absRs{1} = eye(3,3);
    for i = 2:length(imgs)
        absRs{i} = relRs{i-1} * absRs{i-1};
    end
    save("abs_rotation_" + dataset, "absRs");
    disp("done!");
end

% construct initial 3D points from an initial image pair
disp("construct initial 3D points from the initial image pair " + init_pair(1) + " & " + init_pair(2));
% retrieve and save points using SIFT and the pair of images
[f1 d1] = vl_sift( single(rgb2gray(imgs{init_pair(1)}))); 
[f2 d2] = vl_sift( single(rgb2gray(imgs{init_pair(2)}))); 
matches = vl_ubcmatch(d1,d2);
xa = f1(1:2, matches (1 ,:)); 
xb = f2(1:2, matches (2 ,:));
x1 = [xa; ones(1, length(xa))];
x2 = [xb; ones(1, length(xb))];
save("desc_X", "d1");
% estimating best R and T of cameras of the initial pair
[relR, relT, initInlIdx, X] = estimate_R_T_robust(K, inv(K) * x1, inv(K) * x2, pixel_threshold);
% Filter 3D points excessively far away from the center of gravity
disp("number of points before the filter: " + length(X));
X = filter_far_3d_points(X);
disp("number of points adfter the filter: " + length(X));
% bring X to world coordinates and filter out the outliers
X = absRs{init_pair(1)}.' * X(1:3, :);
X = filter_far_3d_points(X);
X = [X; ones(1, length(X))];


desc_X = d1;
descriptors = cell(1, length(imgs));
absTs = cell(1, length(imgs));
for i = 1:length(imgs)
    [fi, descriptors{i}] = vl_sift( single(rgb2gray(imgs{i})));
    matches_2d_3d = vl_ubcmatch(descriptors{i}, desc_X);
    
    inliersIdx = find(initInlIdx);

    % Filter matches where features in the initial image were inliers 
    % from the previous estimation
    inlierMatches = matches_2d_3d(:, ismember(matches_2d_3d(2, :), inliersIdx));
    % Now 'inlierMatches' contains only the matches where the second 
    % feature was an inlier in the initial pair

    % Map the inlier matches to corresponding 3D points
    % This assumes that 'inliersInitial' is aligned with 
    % 'initial3DPoints' indices
    [~, loc] = ismember(inlierMatches(2, :), inliersIdx);
    corrX = X(:, loc);

    % Remove any zeros that might have crept in due to non-inliers
    corrX = corrX(:, all(corrX));

    xi = fi(1:2, inlierMatches(1, :));
    xi = [xi; ones(1, length(xi))];

    focal_length = K(1,1);
    Pi = estimate_T_robust(inv(K) \ xi, corrX, 3 * pixel_threshold / K(1,1));
    absTs{i} = Pi(:, end);
end







