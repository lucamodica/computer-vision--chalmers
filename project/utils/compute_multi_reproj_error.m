function [err, res] = compute_multi_reproj_error(Ps, xs, X)
    allReprojs = cellfun(@(P, x) compute_reprojection_error(P, x, X), ...
        Ps, xs, "UniformOutput", false);
    allReprojs = cellfun(@(out) out(2), allReprojs);

    res = cell2mat(arrayfun(@(r) r{:}, allReprojs)).';
    err = sum(norm(res)^2);
end