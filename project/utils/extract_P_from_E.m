function cameras = extract_P_from_E(E)
    [U, S, V] = svd(E);

    if det(U * V.') <= 0
       V = -V;
    end
    W = [ 
        0 1 0;
        -1 0 0;
        0 0 1
    ];

    u3 = U(:, 3);

    cameras{1} = [U*W*V.', u3];
    cameras{2} = [U*W*V.', -u3];
    cameras{3} = [U*W.'*V.', u3];
    cameras{4} = [U*W.'*V.', -u3];