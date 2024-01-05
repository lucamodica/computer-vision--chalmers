function [r, J] = linearize_reproj_error_wrt_T(R, T, x, X)
    J = [];
    for i = 1:length(X)
        Xi = X(1:3, i);
        df1dt1 = -1 / (R(3, :) * Xi + T(3));
        df1dt2 = 0;
        df1dt3 = 0;
        df2dt1 = 0;
        df2dt2 = -1 / (R(3, :) * Xi + T(3));
        df2dt3 = 0;

        Ji = [
            df1dt1, df1dt2, df1dt3; 
            df2dt1, df2dt2, df2dt3
        ];
        J = [J; Ji];
    end
    
    [~, r] = compute_reprojection_error([R, T], x, X);
    r = reshape(r, 2 * length(X), 1);
end