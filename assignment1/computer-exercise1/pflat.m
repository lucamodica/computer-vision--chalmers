function [y, alpha] = psphere(x);
    % takes a point as input and fla
    % INPUT :
    %  x     - matrix in which each column is a point.
    % OUTPUT :
    %  y     - result after normalization.
    %  alpha - depth

    [a, n] = size(x);
    alpha = sqrt(sum(x .^ 2));
    y = x ./ (ones(a, 1) * alpha);
