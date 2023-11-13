function isEuclidean = is_euclidean_matrix(matrix)
    % Step 1: Calculate the transpose of the matrix
    transposeMatrix = matrix';

    % Step 2: Calculate the inverse of the matrix
    inverseMatrix = inv(matrix);

    % Step 3: Check orthogonality
    isOrthogonal = isequal(transposeMatrix * matrix, matrix * transposeMatrix) && isequal(transposeMatrix * matrix, eye(size(matrix)));

    % Step 4: Check preservation of lengths
    v = randn(size(matrix, 1), 1); % Choose a random vector
    Av = matrix * v; % Compute Av

    % Step 5: Calculate lengths using Euclidean norm
    normV = norm(v);
    normAv = norm(Av);

    % Step 6: Compare lengths
    isPreservingLengths = (normV == normAv);

    % Check if the matrix satisfies both conditions
    isEuclidean = isOrthogonal && isPreservingLengths;