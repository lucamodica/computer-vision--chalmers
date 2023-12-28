function filtered_X = filter_far_3d_points(X)
    % Calculate the center of gravity
    centerOfGravity = mean(X);
    
    % Calculate the Euclidean distance between each point and the center of gravity
    distances = sqrt(sum((X - centerOfGravity).^2, 2));
    
    % Calculate the threshold based on the 90th percentile of the distances
    threshold = 5 * quantile(distances, 0.9);
    
    % Filter points that are excessively far away from the center of gravity
    filtered_X = X(distances <= threshold,:);

    disp("Points filtered: " + num2str(length(X) - length(filtered_X)));
end