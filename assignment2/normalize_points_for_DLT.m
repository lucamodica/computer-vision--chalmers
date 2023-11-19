function [normalized_points] = normalize_points_for_DLT(points)
    ppoints = pflat(points);

    N = standardization_mat(ppoints);

    % normalize points
    normalized_points = N * ppoints;