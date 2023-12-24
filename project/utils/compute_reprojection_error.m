function err = compute_reprojection_error(P, x, X)
    % compute the projetions values for all points
    res = [ x(1, :) - (P(1, :) * X) / (P(3, :) * X), x(2, :) - (P(2, :) * X) / (P(3, :) * X)].'; 
    
    % return the reprojection error
    err = sum(norm(res)^2);