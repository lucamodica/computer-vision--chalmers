function correspondences_2D_3D = create2Dto3DMapping(matches, xNew, X)
    correspondences_2D_3D = [];
    
    % iterate over the matches
    for i = 1:size(matches, 2)
        idx_image_init = matches(1, i);
        idx_new = matches(2, i);
        
        % retrieve the 2D point from the keypoints of the new image
        point_2D_new = xNew(1:2, idx_new);
        
        % since the matches are ordered, the index should correspond to the 3D points directly
        % however, if your 3D points are not ordered this way, you'd need a separate mapping
        X = X(:, idx_image_init);
        
        % append this correspondence to the output list
        % each correspondence is a 2D point from the new image and the matching 3D point
        correspondences_2D_3D = [correspondences_2D_3D; struct('point2D', point_2D_new, 'point3D', X)];
    end
end