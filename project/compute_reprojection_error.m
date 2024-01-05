function [err, res] = compute_reprojection_error(P, x, X)
    res = [ x(1, :) - (P(1,:) * X)/ (P(3,:) * X); ...
        x(2, :) - (P(2,:) * X)/ (P(3,:) * X)];
    
    err = arrayfun(@(col) norm(res(:, col))^2, 1:size(res, 2));
end