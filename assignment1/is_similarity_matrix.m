function isSimilarity = is_similarity_matrix(matrix)
    % Step 1: Check if the matrix is square
    [m, n] = size(matrix);
    if m ~= n
        error('Input matrix must be square.');
    end

    % Step 2: Check if the matrix is orthogonal
    isOrthogonal = isequal(matrix' * matrix, eye(n));

    % Step 3: Check if the matrix has a non-zero determinant
    determinant = det(matrix);
    isNonZeroDeterminant = abs(determinant) > eps;

    % Step 4: Check if the matrix preserves lengths up to a scale factor
    v = randn(n, 1); % Choose a random vector
    Av = matrix * v; % Compute Av

    % Calculate the lengths using Euclidean norm
    normV = norm(v);
    normAv = norm(Av);

    % Compare the lengths
    isPreservingLengths = abs(normV - normAv) < eps;

    % Check if the matrix satisfies all conditions
    isSimilarity = isOrthogonal && isNonZeroDeterminant && isPreservingLengths;
end