function check_lines_parallel_in_3D(ls)

% Check each pair of lines for parallelism
n = size(ls, 1);
parallelPairs = false(n, n);

for i = 1:n
    for j = i+1:n
        ratio = ls(i, :) ./ ls(j, :);
        if abs(ratio(1) - ratio(2)) < 1e-10 && abs(ratio(1) - ratio(3)) < 1e-10
            parallelPairs(i, j) = true;
        end
    end
end

% Display the matrix of parallel pairs
fprintf('Lines parallel? ')
if all(all(parallelPairs)) 
    fprintf('yes\n');
else 
    fprintf('no\n');
end