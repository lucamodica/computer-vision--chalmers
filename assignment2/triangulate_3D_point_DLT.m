function [X] = triangulate_3D_point_DLT(xPoints, P)
    % Number of points
    numPoints = size(xPoints, 2);
    M = zeros(2, 4);
    Xpoints = zeros(4, numPoints);


    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        xi = xPoints(1, i);
        yi = xPoints(2, i);

        % Populate the rows of A
        M(1, :) = [P(1, 1)-xi*P(3, 1), P(1, 2)-xi*P(3,2), P(1, 3)-xi*P(3,3), P(1, 4)-xi*P(3,4)];
        M(2, :) = [P(2, 1)-yi*P(3, 1), P(2, 2)-yi*P(3,2), P(2, 3)-yi*P(3,3), P(2, 4)-yi*P(3,4)];

        [U, S, V] = svd(M);
        Xpoints(:, i) = V(:, end);
    end
 
    X = Xpoints;