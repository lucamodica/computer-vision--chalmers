H1 = [
    sqrt(3), 0, 1;
    1, -sqrt(3), -1;
    0, 0, 1
];
H2 = [
    1, -sqrt(3), 1;
    sqrt(3), 1, 1;
    0, 0, 2
];
H3 = [
    sqrt(5), 1, 1;
    -1, sqrt(5), 1;
    1/2, 1/4, 1
];
H4 = [
    1, -5, 2;
    0, 3, 0;
    sqrt(3), 0, 2 * sqrt(3)
];

% **check for projective transformation**
disp("determinant for each matrix: ");
disp(det(H1))
disp(det(H2))
disp(det(H3))
disp(det(H4))

disp("rank for each matrix: ");
disp(rank(H1))
disp(rank(H2))
disp(rank(H3))
disp(rank(H4))



disp(is_euclidean_matrix(H1))
disp(is_euclidean_matrix(H2))
disp(is_euclidean_matrix(H3))

disp(is_similarity_matrix(H1))
disp(is_similarity_matrix(H2))
disp(is_similarity_matrix(H3))

disp(is_affine_matrix(H1))
disp(is_affine_matrix(H2))
disp(is_affine_matrix(H3))
