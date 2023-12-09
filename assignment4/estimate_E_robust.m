function [bestE, bestInliers] = estimate_E_robust(K, x1, x2)
    %pre-defined threshold (2px) re-scaled by the focal length
    err_threshold_px = 2;
    err_threshold = err_threshold_px / K(1,1);

    bestInliersCount = 0;

    for iteration = 1:1000
        % sample 8 correspondances, the minimum
        % required by the 8-point algorithm
        idxs = randperm(size(x1, 2), 15);
        x1s = x1(:, idxs);
        x2s = x2(:, idxs);

        E = enforce_essential(reshape(estimate_F_DLT(x1s, x2s), [3 3]));

        % compute the error to select the inliers
        inliers = ( compute_epipolar_errors(E, x1 , x2 ).^2 + ...
            compute_epipolar_errors(E', x2 , x1 ).^2 ...
            ) / 2 < err_threshold^2;

        % check if the computed inliers set is better
        % than the best one so far; in case the indexes
        % of the best inliers and the best essential
        % matrix will be updated
        inliersCount = sum(inliers);
        if inliersCount > bestInliersCount
            bestInliersCount = inliersCount;
            bestInliers = inliers;
            bestE = E;
        end
    end