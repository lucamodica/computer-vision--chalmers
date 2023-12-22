function [sol] = estimate_homography_DLT(x1, x2)
    % Number of points
    numPoints = size(x1, 2);
    M = zeros(2 * numPoints, 9);

    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        x = x1(1, i);
        y = x1(2, i);
        u = x2(1, i);
        v = x2(2, i);

        % Populate the rows of M
        M(2 * i - 1, :) = [x, y, 1, 0, 0, 0, -u*x, -u*y, -u];
        M(2 * i, :) = [0, 0, 0, x, y, 1, -v*x, -v*y, -v];
    end

    % solve the system using SVD
    [U, S, V] = svd(M);
    sol = V(:, end);