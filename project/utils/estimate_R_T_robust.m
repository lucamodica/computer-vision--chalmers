function [P, R_best, T_best] = estimate_R_T_robust(K, x1, x2, pixel_threshold)
    % first camera, as defined in a canonical cameras pair
    P1 = [
        1 0 0 0;
        0 1 0 0;
        0 0 1 0
    ];

    focal_length = K(1, 1);

    % define threshold, re-scaled by the focal length
    epipolar_threshold = pixel_threshold / focal_length;
    homography_threshold = 3 * pixel_threshold / focal_length;

    bestInliersCount = 0;
    a = 0.97; % desired percentage of inliers
    s = 8; % number of point in the randomn samples in each iteration for E
    s_H = 4; % number of point in the randomn samples in each iteration for E

    iter_count_E = 0;
    P = [];
    X = [];
    while 1
        % sample 8 correspondances, the minimum
        % required by the 8-point algorithm
        idxs = randperm(size(x1, 2), s);
        x1s = x1(:, idxs);
        x2s = x2(:, idxs);

        E = enforce_essential(reshape(estimate_F_DLT(x1s, x2s), [3 3]));

        % compute the error to select the inliers
        inliers = ( compute_epipolar_errors(E, x1 , x2 ).^2 + ...
            compute_epipolar_errors(E', x2 , x1 ).^2 ...
            ) / 2 < epipolar_threshold^2;

        % check if the computed inliers set is better
        % than the best one so far; in case the indexes
        % of the best inliers and the best essential
        % matrix will be updated
        iter_count_E = iter_count_E + 1; 
        if sum(inliers) > bestInliersCount
            bestInliersCount = sum(inliers);
            bestInliers = inliers;

            disp("T_E new best inliers count: " + bestInliersCount);

            % update iter count and number of iters for E
            eps_E = bestInliersCount / length(x1);
            T_E = ceil(log(1-a)/log(1-eps_E^s));
    
            % extract R and T from E
            [P, X] = find_best_P2(E, x1, x2, P1, K, bestInliers);
            R_best = P(:, 1:3);
            T_best = P(:, 4);

            % check for loop exit condition
            if T_E <= iter_count_E 
                break; 
            end
        end

        % estimating H
        idxs = randperm(size(x1, 2), s_H);
        x1s = x1(:, idxs);
        x2s = x2(:, idxs);
        H = reshape(estimate_homography_DLT(x1s, x2s), [3, 3]);

        % extract R1, t1, R2 and t2 to then compute the
        % candidate E matrices
        [R1, t1, R2, t2] = homography_to_RT(H, x1, x2);
        E1 = enforce_essential(skew(t1) * R1);
        E2 = enforce_essential(skew(t2) * R2);

        % compute the error to select the inliers using E1 and E2
        inliersE1 = ( compute_epipolar_errors(E1, x1 , x2 ).^2 + ...
            compute_epipolar_errors(E1', x2 , x1 ).^2 ...
            ) / 2 < homography_threshold^2;
        inliersE2 = ( compute_epipolar_errors(E2, x1 , x2 ).^2 + ...
            compute_epipolar_errors(E2', x2 , x1 ).^2 ...
            ) / 2 < homography_threshold^2;

        if sum(inliersE1) > bestInliersCount || sum(inliersE2) > bestInliersCount
            if sum(inliersE1) > sum(inliersE2)
                bestE = E1;
                bestInliersCount = sum(inliersE1);
                bestInliers = inliersE1;
                disp("T_E1 new best inliers count: " + bestInliersCount);
            else
                bestE = E2;
                bestInliersCount = sum(inliersE2);
                bestInliers = inliersE2;
                disp("T_E2 new best inliers count: " + bestInliersCount);
            end

            % update iter count and number of iters for E
            eps_H = bestInliersCount / length(x1);
            T_H = ceil(log(1-a)/log(1-eps_H^s_H));
    
            % extract R and T from E
            [P, X] = find_best_P2(bestE, x1, x2, P1, K, bestInliers);
            R_best = P(:, 1:3);
            T_best = P(:, 4);

            % check for loop exit condition
            if T_H <= iter_count_E 
                break; 
            end
        end
    end

    disp("number of inliers: " + bestInliersCount); 
    P2u = P;
    P1u = K * P1;
    figure;
    plot3(X(1, :), X(2, :), X(3, :), 'b.');
    hold on;
    [C1, ~] = camera_center_and_axis(P1u);
    plot_camera(P1, 0.4);
    text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
    [C2, ~] = camera_center_and_axis(P2u);
    plot_camera(P, 0.4);
    text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
    title("3D reconstruction of the building with P1 and extracted camera ");