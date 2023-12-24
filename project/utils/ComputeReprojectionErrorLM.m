function [err,res] = ComputeReprojectionErrorLM(P_1,P_2,X_j,x_1j,x_2j)
        row1 = [ x_1j(1, :) - (P_1(1, :) * X_j) / (P_1(3, :) * X_j), x_1j(2, :) - (P_1(2, :) * X_j) / (P_1(3, :) * X_j)];
        row2 = [ x_2j(1, :) - (P_2(1, :) * X_j) / (P_2(3, :) * X_j), x_2j(2, :) - (P_2(2, :) * X_j) / (P_2(3, :) * X_j)];

    res = [row1, row2].';
    err = sum(norm(res)^2);