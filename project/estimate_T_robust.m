function best_T = estimate_T_robust(xs, Xs, R, inlier_threshold)
    num_iterations = 2000;
    best_T = [];
    best_inliers = [];
    best_eps = 0;
    
    for i = 1:num_iterations
        indices = randperm(size(xs, 2), 2);
        xs_sample = xs(:, indices);
        Xs_sample = Xs(:, indices);

        T = estimate_T_DLT(xs_sample, Xs_sample, R);
        proj = pflat([R, T] * Xs);
        inliers = ((sqrt(sum((xs - proj).^2, 1))) / 2) < inlier_threshold;

        eps = sum(inliers) / length(xs);

        % Update the best model if the current one has more inliers
        if eps > best_eps
            best_eps = eps;
            best_inliers = inliers;
            best_T = T;
        end
    end
    
    % Optional: Refine the pose with all inliers
    if isempty(best_inliers)
        % return a default value
        best_T = [0; 0; 1];
        warning(['RANSAC was unable to find a good pose with the given ' ...
            'inlier threshold']);
    end
end

