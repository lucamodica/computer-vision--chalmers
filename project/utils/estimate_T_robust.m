function T = estimate_T_robust(xs, Xs, inlier_threshold)
    bestInlsCount = 0;
    bestDLTmatrix = [];

    for i = 1:100
        % Step 2: Randomly select minimal subset of correspondences
        subsetIndices = randperm(numCorrespondences, 4);
        subsetImagePoints = imagePoints(:, subsetIndices);
        subsetScenePoints = scenePoints(:, subsetIndices);
    end
end