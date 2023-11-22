function [M] = DLT_matrix(XModel, xModel)
    % Number of points
    numPoints = size(XModel, 2);
    M = zeros(2 * numPoints, 12);

    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        X = XModel(1, i);
        Y = XModel(2, i);
        Z = XModel(3, i);
        x = xModel(1, i);
        y = xModel(2, i);

        % Populate the rows of A
        M(2 * i - 1, :) = [X, Y, Z, 1, 0, 0, 0, 0, -x*X, -x*Y, -x*Z, -x];
        M(2 * i, :) = [0, 0, 0, 0, X, Y, Z, 1, -y*X, -y*Y, -y*Z, -y];
    end