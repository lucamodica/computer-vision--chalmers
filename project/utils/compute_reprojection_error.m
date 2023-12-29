function [err] = compute_reprojection_error(P1,x_1j, X_j)
    err = [];
    for i = 1:length(x_1j)
        res(:,i) = [x_1j(1,i) - (P1(1,:) * X_j)/ (P1(3,:) * X_j), x_1j(2,i) - (P1(2,:) * X_j)/ (P1(3,:) * X_j)];
        err = [err,norm(res(:,i))^2];
    end
end