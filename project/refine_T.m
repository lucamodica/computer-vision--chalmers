function T = refine_T(T_init, R, x, X)
    % init
    T = T_init;
    iters = 100;
    mu = 0.01;

    % compute first reprojection error, among all the points
    err = sum(compute_reprojection_error([R, T], x, X));

    disp("Error before LM: " + err);
    % iteratively refine T
    for i = 1:iters
        [r, J] = linearize_reproj_error_wrt_T(R, T, x, X);
        dT = compute_update_LM(r, J, mu);
        new_err = sum(compute_reprojection_error([R, T + dT], x, X));

        if new_err < err
            T = T + dT;
            mu = mu / 10;
            err = new_err;
        else
            mu = mu * 10;
        end
    end
    disp("Error after LM: " + err);
end