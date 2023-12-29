function T = estimate_T_DLT(xs, Xs, R)
    % Number of correspondences
    n = size(xs, 2);
    M = [];
    
    for i = 1:n
        % Get the i-th correspondence
        xi = xs(:, i);
        Xi = Xs(1:3, i);
        
        Mi = [skew(xi), skew(xi) * R];
        M = [M; Mi]; 
    end
    
    % solve the system using SVD
    [~, ~, V] = svd(M);
    T = pflat(V(1:3, end));
end