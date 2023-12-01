function [N] = standardization_mat(points)
    % pflat the points first
    ppoints = pflat(points);

    % compute the necessary values for the
    % normalization
    meanX = mean(ppoints(1, :));
    meanY = mean(ppoints(2, :));
    stdX = std(ppoints(1, :));
    stdY = std(ppoints(2, :));

    % print the values that will be used for N
    disp("Mean for coordinate X: " + meanX);
    disp("Mean for coordinate Y: " + meanY);
    disp("Standard deviation for coordinate X: " + stdX);
    disp("Standard deviation for coordinate Y: " + stdY);

    % construct the tranformation matrix
    N = [
      1/stdX, 0, -(meanX/stdX);
      0, 1/stdY, -(meanY/stdY);
      0, 0, 1
    ];