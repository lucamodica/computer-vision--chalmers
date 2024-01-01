function delta = compute_update_LM(r, J, mu)
    C = J.'* J + mu*eye(size(J ,2)); 
    c = J.'* r;
    delta = (-C)^(-1) * c;