function filtered_X = filter_far_3d_points(X)
    thresholdfactor = 5;
    centroid = mean(X);

    % Calculate the distances from each point to the centroid
    distances = vecnorm(X - centroid, 2, 2);

    % Calculate the threshold based on the 90th percentile of distances
    threshold = thresholdfactor * prctile(distances, 90);

    filtered_X = X(distances <= threshold, :);
end