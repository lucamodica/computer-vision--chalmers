%% Project init
% clear environment
close all;
clc;
clear;

% debugging flag
debug_mode = true;

% add all the function in the utls folder to the working path
addpath utils/;
addpath data/;

% load vlfeat library (replace the parameter with your 
% path to vl_setup.m file in vlfeat library folder)
run("/home/lucamodica/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup.m");

% setting a fixed random seed (especially for debugging purposes)
if debug_mode
    rng(42);
end
    
% retrieve and return information of the selected dataset
% (replace the get_dataset_info parameter with the number
% of the dataset)
dataset = 2;
[K, img_names, init_pair, pixel_threshold] = get_dataset_info(dataset);
    
% save the images in a cell struct
imgs = cellfun(@(name) imread(name), img_names, 'UniformOutput', false);
numImages = length(imgs);
%%

%% Computing sift desc and feat for each image in the dataset
disp("Computing sift descriptors and features for each image in the dataset...");
if debug_mode && exist("sift_infos_" + dataset + ".mat", "file")
    load("sift_infos_" + dataset + ".mat");
    disp("Sift descriptors and features for each image already found and loaded!");
else
    feats = cell(1, numImages);
    descs = cell(1, numImages);
    for i = 1:numImages
        [feats{i}, descs{i}] = vl_sift( single(rgb2gray(imgs{i}))); 
    end

    save("sift_infos_" + dataset, "feats", "descs");
    disp("Done!");
end
%%

%% Computing the relative orientations (R and T) for each pair of images (i, i+1)
disp("Computing the relative orientations (R and T) for each pair of images (i, i+1)...");

if debug_mode && exist("rel_orientation_" + dataset + ".mat", "file")
    load("rel_orientation_" + dataset + ".mat");
    disp("Relative orientations already found and loaded!");
else
    relRs = cell(1, numImages - 1);
    relTs = cell(1, numImages - 1);
    for i = 1:length(imgs)-1
        % computing and homogenaize point matches between 
        % the pair (i, i+1)
        matches = vl_ubcmatch(descs{i},descs{i+1});
        xa = feats{i}(1:2, matches(1, :)); 
        xb = feats{i+1}(1:2, matches(2, :));
        xInit1 = [xa; ones(1, length(xa))];
        xInit2 = [xb; ones(1, length(xb))];
        
        % estimating best R and T of the the P2 camera
        [relRs{i}, relTs{i}, inls, initX] = estimate_R_T_robust( ...
            K, xInit1, xInit2, pixel_threshold);
        initX = filter_far_3d_points(initX);
    
        % plot the inlier 3D points and the resulting relative camera 
        % for checking the correctness of the current relative 
        % pose (debug mode)
        if debug_mode
            P1 = [eye(3, 3), zeros(3, 1)];
            P2 = [relRs{i}, relTs{i}];
            figure;
            plot3(initX(1, :), initX(2, :), initX(3, :), 'b.');
            hold on;
            grid on;
            axis equal;
            [C1, ~] = plot_camera(K * P1, 1);
            text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
            [C2, ~] = plot_camera(K * P2, 1);
            text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
            title("Relative orientation between camera " + i + " and " + num2str(i+1));
            
            disp("Relative oriantation between camera " + i + " and " + num2str(i+1) + " computed!");
        end
    end
    save("rel_orientation_" + dataset, "relRs", "relTs");
    disp("done!");
end
%%

%% Upgrade relative rotations to absolute rotations, for each image
disp("Upgrade relative rotations to absolute rotations, for each image...");
if debug_mode && exist("abs_rotation_" + dataset + ".mat", "file")
    load("abs_rotation_" + dataset + ".mat");
    disp("Absolute rotations already found and loaded!")
else
    absRs = cell(1, numImages);
    % Upgrade to absolute rotations R_i for each image i
    % using the rotation averaging method
    absRs{1} = eye(3,3);
    for i = 2:length(imgs)
        absRs{i} = relRs{i-1} * absRs{i-1};
    end
    save("abs_rotation_" + dataset, "absRs");
    disp("done!");
end
%%

%% construct initial 3D points from an initial image pair
disp("construct initial 3D points from the initial image pair " + ...
    init_pair(1) + " & " + init_pair(2));
if debug_mode && exist("init_3D_inls_" + dataset + ".mat", "file")
    load("init_3D_inls_" + dataset + ".mat");
    disp("Initial 3D points and inliers already found and loaded!");
else
    % retrieve and save points using SIFT and the pair of images
    dInit1 = descs{init_pair(1)};
    fInit1 = feats{init_pair(1)};
    dInit2 = descs{init_pair(2)};
    fInit2 = feats{init_pair(2)};
    
    initMatches = vl_ubcmatch(dInit1,dInit2);
    xa = fInit1(1:2, initMatches(1, :)); 
    xb = fInit2(1:2, initMatches(2, :));
    xInit1 = [xa; ones(1, length(xa))];
    xInit2 = [xb; ones(1, length(xb))];
    % calculate relative orientation for the initial pair alongside
    % the initial inliers 3D points
    [~, ~, initInlIdx, initX] = estimate_R_T_robust( ...
        K, xInit1, xInit2, pixel_threshold);
    % Filter 3D points excessively far away from the center of gravity and
    % bring X to world coordinates and filter out the outliers
    initX = filter_far_3d_points(absRs{init_pair(1)}.' * initX(1:3, :));
    initX = [initX; ones(1, length(initX))];

    save("init_3D_inls_" + dataset, "initX", "initInlIdx");
    disp("done!");
end
%%

%% Compute absolute rotation for each image with translation registration
disp("Compute robustly the absolute trnaslation for each image with " + ...
    "translation registration and the initial 3D points...");
if debug_mode && exist("abs_translation_" + dataset + ".mat", "file")
    load("abs_translation_" + dataset + ".mat");
    disp("Absolute translations for each image already found and loaded!");
else
    absTs = cell(1, length(imgs));
    for i = 1:length(imgs)
        matches_2d_3d = vl_ubcmatch(descs{i}, descs{init_pair(1)});
    
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
        corrX = initX(:, loc);
        % Remove any zeros that might have crept in due to non-inliers
        corrX = corrX(:, all(corrX));
        xi = feats{i}(1:2, inlierMatches(1, :));

        xin = pflat(K \ [xi; ones(1, length(xi))]);
        Xin = [(K \ corrX(1:3, :)); ones(1, length(corrX))];
        absTs{i} = estimate_T_robust(xin, Xin, absRs{i}, 20 * pixel_threshold / K(1,1));

        disp("Absolute translation for camera " + i + " computed!");
    end

    save("abs_translation_" + dataset, "absTs");
    disp("done!");
end
%%

%% Constructing the absolute cameras for each image
Ps = cellfun(@(R, T) [R, T], absRs, absTs, 'UniformOutput', false);
%%

%% test plotting init 3d points and all the cameras
figure;
plot3(initX(1, :), initX(2, :), initX(3, :), 'b.');
grid on;
hold on;
axis equal;
for i = 1:length(Ps)
    P = K * Ps{i};
    [C1, ~] = plot_camera(P, 0.5);
    text(C1(1), C1(2), C1(3), "C" + num2str(i), 'FontSize', 12, 'HorizontalAlignment', 'right');
end
%%

%% Triangulate points for all pairs (i, i+1) 
%%

%% Visualize 3D points + cameras
%%



