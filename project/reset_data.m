function reset_data(dataset)
    % names of the files to delete in order
    % to reset all the computation for a specific
    % dataset (in the current working folder)
    filePrefixes = {"abs_rotation_", "abs_translation_", "rel_orientation_inls_", "sift_infos_", "init_3D_inls_"};

    % delete files
    for i = 1:length(filePrefixes)
        fileName = filePrefixes{i} + dataset + ".mat";
        if exist(fileName, 'file') == 2
            delete(fileName);
            disp('Deleted file: ' + fileName);
        else
            disp('File not found: ' + fileName);
        end
    end
end