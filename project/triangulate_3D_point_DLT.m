function [X] = triangulate_3D_point_DLT(x1, x2, P1, P2)
    % Number of points
    numPoints = size(x1, 2);
    M = zeros(2, 4);
    Xpoints = zeros(4, numPoints);


    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        xi1 = x1(1, i);
        yi1 = x1(2, i);
        xi2 = x2(1, i);
        yi2 = x2(2, i);

        % Populate the rows of A
        M(1, :) = [P1(1, 1)-xi1*P1(3, 1), P1(1, 2)-xi1*P1(3,2), P1(1, 3)-xi1*P1(3,3), P1(1, 4)-xi1*P1(3,4)];
        M(2, :) = [P1(2, 1)-yi1*P1(3, 1), P1(2, 2)-yi1*P1(3,2), P1(2, 3)-yi1*P1(3,3), P1(2, 4)-yi1*P1(3,4)];
        M(3, :) = [P2(1, 1)-xi2*P2(3, 1), P2(1, 2)-xi2*P2(3,2), P2(1, 3)-xi2*P2(3,3), P2(1, 4)-xi2*P2(3,4)];
        M(4, :) = [P2(2, 1)-yi2*P2(3, 1), P2(2, 2)-yi2*P2(3,2), P2(2, 3)-yi2*P2(3,3), P2(2, 4)-yi2*P2(3,4)];

        [~, ~, V] = svd(M);
        Xpoints(:, i) = V(:, end);
    end
 
    X = Xpoints;