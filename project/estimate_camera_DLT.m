function P = estimate_camera_DLT(xs, Xs)
    % Number of points
    numPoints = size(Xs, 2);
    M = zeros(2 * numPoints, 12);

    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        X = Xs(1, i);
        Y = Xs(2, i);
        Z = Xs(3, i);
        x = xs(1, i);
        y = xs(2, i);

        % Populate the rows of A
        M(2 * i - 1, :) = [X, Y, Z, 1, 0, 0, 0, 0, -x*X, -x*Y, -x*Z, -x];
        M(2 * i, :) = [0, 0, 0, 0, X, Y, Z, 1, -y*X, -y*Y, -y*Z, -y];
    end

    % solve the system using SVD
    [~, ~, V] = svd(M);
    P = reshape(V(:, end), [3 4]);
end