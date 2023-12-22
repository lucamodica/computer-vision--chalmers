function [sol] = estimate_camera_DLT(X, x)
    M = DLT_matrix(X, x);

    % solve the system using SVD
    [U, S, V] = svd(M);
    sol = V(:, end);