function [errs] = compute_epipolar_errors(F, x1s, x2s)
    % compute the epipolar lines
    l = F*x1s;
    % Makes sure that the line has a unit normal 
    % (makes the distance formula easier) 
    l = l./sqrt(repmat(l(1,:).^2 + l(2 ,:).^2 ,[3 1]));

    % populate ds, which is the vector containing all
    % distances between the points and the corresponding
    % epipolar lines. The distances will actually represent
    % the epipolar errors
    errs = abs(sum(l .* x2s));
end

