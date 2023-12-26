function [err, res] = single_reprojection_err(P, T, X_j, x_j)
    % compute the reprojection error given a new translation vector T

    P(:, 4) = T;

    % compute reprojection
    res = [ x_j(1, :) - (P(1, :) * X_j) / (P(3, :) * X_j), x_j(2, :) 
        - (P(2, :) * X_j) / (P(3, :) * X_j)].';

    % Compute the error as the sum of squared differences for this point
    err = sum(norm(res)^2);
end

