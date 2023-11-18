function [normalized_points] = normalize_points_for_DLT(points)
    % pflat the points first
    ppoints = pflat(points);

    % compute the necessary values for the
    % normalization
    meanX = mean(ppoints(1, :));
    meanY = mean(ppoints(2, :));
    stdX = std(ppoints(1, :));
    stdY = std(ppoints(2, :));

    % normalize points
    normalized_points = ppoints;
    normalized_points(1, :) = (ppoints(1, :) - meanX) / stdX;
    normalized_points(2, :) = (ppoints(2, :) - meanY) / stdY;