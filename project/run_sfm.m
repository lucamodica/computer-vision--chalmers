function run_sfm(dataset)
    % add all the function in the utls folder to the working path
    addpath utils/;
    addpath data/;

    % load vlfeat library (replace the parameter with your 
    % path to vl_setup.m file in vlfeat library folder)
    run("/home/lucamodica/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup.m");

    % setting a fixed random seed (especially for debugging purposes)
    rng(100);
    
    % retrieve and return information of the selected dataset
    % (replace the get_dataset_info parameter with the number
    % of the dataset)
    [K, img_names, init_pair, pixel_threshold] = get_dataset_info(dataset);
    
    % save the images in a cell struct
    imgs = cellfun(@(name) imread(name), img_names, 'UniformOutput', false);

    
end