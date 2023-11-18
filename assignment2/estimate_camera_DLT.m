function [sol] = estimate_camera_DLT(X, x)
    M = cross(x, X);

    % solve the system using SVD
    [U, S, V] = svd(M);
    sol = V(:, end);