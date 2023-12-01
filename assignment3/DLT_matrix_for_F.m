function [M] = DLT_matrix_for_F(x1s, x2s)
    % Number of points
    numPoints = length(x1s);
    M = zeros(numPoints, 9);

    % Iterate over the points and populate the matrix M
    for i = 1:numPoints
        % Populate the rows of M
        xx = x2s(:,i)*x1s(:,i)';
        M(i, :) = xx(:)';
    end