function [r, J] = linearize_reproj_error_wrt_T(R, T, x, X)
    % the Jacobian for the reprojection error for a 3D
    % point is the negative of the identity matrix

    J = repmat(-eye(2, 3), length(X), 1);
    [~, r] = compute_reprojection_error([R, T], x, X);
    r = reshape(r, [2 * length(x), 1]);