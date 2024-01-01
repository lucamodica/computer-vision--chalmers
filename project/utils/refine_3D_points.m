function X = refine_3D_points(X_init, Ps, xs)
    % init
    X = X_init;
    iters = 100;
    mu = 0.01;

    % compute first reprojection error, among all
    % the points for all cameras
    err = compute_multi_reproj_error(Ps, xs, X);
    disp("Initial reprojection error: " + err);

    % iteratively refine 3D points
    for i = 1:iters
        [r, J] = linearize_reproj_error_wrt_T(R, T, x, X);
        dX = compute_update_LM(r, J, mu);
        new_err = compute_multi_reproj_error(Ps, xs, X + dX);

        if new_err < err
            X = X + dX;
            mu = mu / 10;
            err = new_err;
        else
            mu = mu * 10;
        end
    end

    disp("Reprojection error after refinment: " + err);
end