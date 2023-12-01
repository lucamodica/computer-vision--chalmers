function [v] = estimate_F_DLT(x1s, x2s)
    %%
    % note: this function will return the solution
    % found with SVD (the last column of v transposed),
    % not F itself
    %%
    M = DLT_matrix_for_F(x1s, x2s);

    [U, S, V] = svd(M);

    disp("Minimum singular value: " + min(min(S)));

    v = V(:, end);