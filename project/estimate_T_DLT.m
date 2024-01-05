function T = estimate_T_DLT(xs, Xs, R)

    xskew1 = skew(xs(:, 1));
    xskew2 = skew(xs(:, 2));
    A = [xskew1; xskew2];

    b = [-xskew1 * R * Xs(1:3, 1); -xskew2 * R * Xs(1:3, 2)];

    T = A \ b;
end