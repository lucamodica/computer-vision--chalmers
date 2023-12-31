function best_T = estimate_T_robust(xs, Xs, R, inlier_threshold)
    num_iterations = 2000;
    best_inlier_count = 0;
    best_T = [];
    best_inliers = [];
    
    for i = 1:num_iterations
        indices = randperm(size(xs, 2), 2);
        xs_sample = xs(:, indices);
        Xs_sample = Xs(:, indices);

        T = estimate_T_DLT(xs_sample, Xs_sample, R);
        P = [R, T];
        inliers = compute_reprojection_error(P, xs, Xs) < inlier_threshold^2;

        % Update the best model if the current one has more inliers
        if sum(inliers) > best_inlier_count
            best_inlier_count = sum(inliers);
            best_inliers = inliers;
            best_T = P(:, end);
        end
    end
    
    % Optional: Refine the pose with all inliers
    if ~isempty(best_inliers)
        % refining T using LM method
        best_T = refine_T(best_T, R, xs, Xs);
    else
        best_T = [];
        warning(['RANSAC was unable to find a good pose with the given ' ...
            'inlier threshold']);
    end
end

