function [best_R, best_T, best_inliers, best_X] = estimate_R_T_robust(K, x1, x2, pixel_threshold)
    % first camera, as defined in a canonical cameras pair
    P1 = [
        1 0 0 0;
        0 1 0 0;
        0 0 1 0
    ];

    % normalize points
    x1 = K \ x1;
    x2 = K \ x2;

    focal_length = K(1, 1);

    % define thresholds, re-scaled by the focal length
    epipolar_threshold = pixel_threshold / focal_length;
    homography_threshold = 3 * pixel_threshold / focal_length;

    % probability to have an all-inlier set 
    % (both for E and H estimations)
    a = 0.97;

    inlE = [];
    % num of point correspondances to estimate E
    sE = 8;
    % flag to indicate that we reached the required number
    % of iteration in the E matrix estimation part
    breakE = false;
    R_best_E = eye(3,3);
    T_best_E = zeros(3);
    X_E = [];
    epsE = 0.05;

    inlH = [];
    % num of point correspondances to estimate H
    sH = 4;
    % flag to indicate that we reached the required number
    % of iteration in the E matrix estimation part
    breakH = false;
    R_best_H = eye(3,3);
    T_best_H = zeros(3);
    X_H = [];
    epsH = 0.05;

    itersCount = 0;
    maxItersCount = 10000;
    while 1
        % **E estimation part**
        if ~breakE
            % sample 8 correspondances, the minimum
            % required by the 8-point algorithm
            idxs = randperm(size(x1, 2), sE);
            x1s = x1(:, idxs);
            x2s = x2(:, idxs);
    
            % estimating E
            E = enforce_essential(reshape(estimate_F_DLT(x1s, x2s), [3 3]));
    
            % compute the errors to select the inliers
            inliers = ( compute_epipolar_errors(E, x1 , x2 ).^2 + ...
                compute_epipolar_errors(E', x2 , x1 ).^2 ...
                ) / 2 < epipolar_threshold^2;
    
            % check if we obtain a greater number of inliers
            % compared to the last matrix E estimation
            if sum(inliers) / length(x1) > epsE
                inlE = inliers;
    
                % disp("new best inliers count is from E: " + bestInlCountE);

                % extract R and T from E
                [P, X_E_curr] = find_best_P2(E, x1, x2, P1, inliers);

                % update the values if the essential matrix
                % is acceptable
                if P ~= zeros(3, 4)
                    % update iter count and number of iters for E
                    epsE = sum(inlE) / length(x1);
                    itersE = ceil(log(1-a)/log(1-epsE^sE));
            
                    X_E = X_E_curr;
                    R_best_E = P(:, 1:3);
                    T_best_E = P(:, 4);
        
                    % check for loop exit condition, setting the
                    % related flag in case of number of iteration
                    % required reached
                    if itersE + 5000 <= itersCount 
                        breakE = true; 
                    end
                end
            end
        end

        % **H estimation part**
        if ~breakH
            % sample 4 correspondances to estimate an
            % homography using DLT
            idxs = randperm(size(x1, 2), sH);
            x1s = x1(:, idxs);
            x2s = x2(:, idxs);

            % estimate H
            H = reshape(estimate_homography_DLT(x1s, x2s), [3, 3]);
    
            % extract R1, t1, R2 and t2 to then compute the
            % candidate E1 and E2 matrices
            [R1, t1, R2, t2] = homography_to_RT(H, x1, x2);
            E1 = enforce_essential(skew(t1) * R1);
            E2 = enforce_essential(skew(t2) * R2);
    
            % compute the errors to select the inliers using E1 and E2
            inliersE1 = ( compute_epipolar_errors(E1, x1 , x2 ).^2 + ...
                compute_epipolar_errors(E1', x2 , x1 ).^2 ...
                ) / 2 < homography_threshold^2;
            inliersE2 = ( compute_epipolar_errors(E2, x1 , x2 ).^2 + ...
                compute_epipolar_errors(E2', x2 , x1 ).^2 ...
                ) / 2 < homography_threshold^2;
    
            % check if we obtain a greater number of inliers
            % compared to the last matrix H estimation, with
            % either E1 or E2
            if sum(inliersE1) / length(x1) > epsH || sum(inliersE2) / length(x1) > epsH
                % with the same criteria, we will 
                % choose between E1 and E2
                if sum(inliersE1) > sum(inliersE2)
                    bestE = E1;
                    inlBestE = inliersE1;
                else
                    bestE = E2;
                    inlBestE = inliersE2;
                end
    
                % extract R and T from E
                [P, X_H_curr] = find_best_P2(bestE, x1, x2, P1, inlBestE);

                % if the camera is an eligible one,
                % R, T and the epsilon will be updated
                if P ~= zeros(3, 4)
                    X_H = X_H_curr;
                    inlH = inlBestE;

                    R_best_H = P(:, 1:3);
                    T_best_H = P(:, 4);

                    % update iter count and number of iters for E
                    epsH = sum(inlH) / length(x1);
                    itersH = ceil(log(1-a)/log(1-epsH^sH));
        
                    % check for loop exit condition, setting the
                    % related flag in case of number of iteration
                    % required reached
                    if itersH + 5000 <= itersCount 
                        breakH = true;
                    end
                end
            end
        end
        
        itersCount = itersCount + 1;

        % if both breakE and breakH flag are true, or
        % the iteration general threshold is reached,
        % exit from the RANSAC loop
        if (breakE && breakH) || itersCount >= maxItersCount
            break;
        end
    end

    disp("number of iterations: " + itersCount);
    disp("number of inliers from E: " + sum(inlE));
    disp("number of inliers from H: " + sum(inlH));

    % return the best R and T based where we obtain
    % more inliers, between E estimation and H
    % estimation
    if sum(inlE) > sum(inlH)
        best_R = R_best_E;
        best_T = T_best_E;
        best_inliers = inlE;
        best_X = X_E;
    else
        best_R = R_best_H;
        best_T = T_best_H;
        best_inliers = inlH;
        best_X = X_H;
    end