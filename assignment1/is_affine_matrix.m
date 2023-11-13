function isAffine = is_affine_matrix(matrix)
    % Step 1: Check if the matrix is square
    [m, n] = size(matrix);
    if m ~= n
        error('Input matrix must be square.');
    end
    
    % Step 2: Check if the bottom row is [0 0 ... 0 1]
    bottomRow = matrix(end, :);
    isBottomRowCorrect = isequal(bottomRow, [zeros(1, n-1), 1]);

    % Step 3: Check if the top-left (n-1) x (n-1) submatrix is invertible
    submatrix = matrix(1:end-1, 1:end-1);
    isSubmatrixInvertible = abs(det(submatrix)) > eps;
    
    % Check if the matrix satisfies all conditions
    isAffine = isBottomRowCorrect && isSubmatrixInvertible;