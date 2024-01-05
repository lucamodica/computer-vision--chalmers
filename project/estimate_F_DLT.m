function [v] = estimate_F_DLT(x1s, x2s)
    %%
    % note: this function will return the solution
    % found with SVD (the last column of v transposed),
    % not F itself
    %%
    M = DLT_matrix_for_F(x1s, x2s);

    [~, ~, V] = svd(M);

    v = V(:, end);
end