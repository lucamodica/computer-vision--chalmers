function [P2, X] = find_best_P2(E, x1n, x2n, P1, K, inliersIdxs)
    % compute the 4 cameras to choose P2
    cameras = extract_P_from_E(E);
    P2 = zeros(3, 4);
    X = [];
    bestFrontCount = 0;

    for i = 1:4
        Xt = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{i}));
        Xt = Xt(:, inliersIdxs);
        xtP1 = P1 * Xt;
        xtP2 = cameras{i} * Xt;

        % check for 95% inliers in front of both cameras and
        % if it's a new best camera
        frontCount = sum(xtP1(3,:) > 0) + sum(xtP2(3,:) > 0);
        if frontCount > bestFrontCount
            bestFrontCount = frontCount;
            X = Xt;
            P2 = cameras{i};
        end
    end
