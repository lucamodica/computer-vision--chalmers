function [E] = enforce_essential(E_approx)
    [U, S, V] = svd(E_approx);

    if det(U*V') < 0 
        V = -V; 
    end 
    E = U*diag ([1 1 0])*V'; 