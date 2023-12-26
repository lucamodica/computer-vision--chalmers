function best_P = estimate_T_robust(xs, Xs, inlier_threshold)
    num_iterations = 1000;
    best_inlier_count = 0;
    best_P = [];
    
    for i = 1:num_iterations
        indices = randperm(size(xs, 1), 2);
        xs_sample = xs(:, indices);
        Xs_sample = Xs(:, indices);

        P = estimate_camera_DLT(xs_sample, Xs_sample); 
        inliers = compute_reprojection_error(P, xs, Xs) < inlier_threshold^2;

        % Update the best model if the current one has more inliers
        if length(inliers) > best_inlier_count
            best_inlier_count = length(inliers);
            best_inliers = inliers;
            best_P = P;
        end
    end
    
    % Optional: Refine the pose with all inliers
    if ~isempty(best_inliers)
        % [best_rotation, best_translation] = refinePosePnP(xs(best_inliers, :), Xs(best_inliers, :), best_P);
        % best_P = P;
    else
        best_P = [];
        warning('RANSAC was unable to find a good pose with the given inlier threshold');
    end
end

% Placeholder function for pose refinement (to be replaced with actual implementation)
% function [rotation, translation] = refinePosePnP(xs, Xs, initial_P)
%     % This function should refine the pose given the inliers and an initial estimate.
%     % It can use non-linear optimization functions like 'lsqnonlin'.
%     % [rotation, translation] = some_refinement_procedure(xs, Xs, initial_P);
% end

