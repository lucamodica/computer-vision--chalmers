function errs = compute_reprojection_error(P, x, X)
    projx = pflat(P * X);
    errs = [];

    % compute the squared norm for each point
    for i = 1:length(X)
        errs = [errs, norm(projx(:, i) - x(:, i))^2];
    end