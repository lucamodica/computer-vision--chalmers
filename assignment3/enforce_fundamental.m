function [A] = enforce_fundamental(F_approx)
    [U, S, V] = svd(F_approx);

    S(3, 3) = 0;
    A = U * S * V.';