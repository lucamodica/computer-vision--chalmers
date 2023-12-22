function [K, image_names, init_pair] = init_project(dataset)
    % clear environment
    close all;
    clc;
    clear;
    
    % load vlfeat library (replace the parameter with your 
    % path to vl_setup.m file in vlfeat library folder)
    run("/home/lucamodica/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup.m");
    
    % setting a fixed random seed (especially for debugging purposes)
    rng(100);

    % retrieve and return information of the selected dataset
    [K, image_names, init_pair] = get_dataset_info(dataset);
end