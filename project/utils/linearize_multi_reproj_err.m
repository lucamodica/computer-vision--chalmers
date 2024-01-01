function [r, J] = linearize_multi_reproj_err(Ps, xs, X)
    % anonymous func to create a Jacobian row
    % for the camera i and its related 2d points
    Ji = @(P) [
        (((P(1, :) * X) / (P(3, :) * X)^2) * P(3, :)) - ((1 / (P(3, :) * X)) * P(1, :));
        (((P(2, :) * X) / (P(3, :) * X)^2) * P(3, :)) - ((1 / (P(3, :) * X)) * P(2, :))
    ];

    J = arrayfun(Ji, Ps).';
    [~, r] = compute_multi_reproj_error(Ps, xs, X);
end