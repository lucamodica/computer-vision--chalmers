close all;
clear;


rng('default') % For reproducibility
warning('off', 'all')

disp("no noise")
[totErr1, totErrLM1, medianErr1, medianErrLM1] = compex3(0, 0);

disp("noise on 3D points")
[totErr2, totErrLM2, medianErr2, medianErrLM2] = compex3(0.1, 0);

disp("noise on 2D points")
[totErr3, totErrLM3, medianErr3, medianErrLM3] = compex3(0, 3);

disp("noise on both")
[totErr4, totErrLM4, medianErr4, medianErrLM4] = compex3(0.1, 3);

% Line plot for the total reprojection errors
figure;
plot(1:4,[ ...
    abs(totErrLM1 - totErr1), ...
    abs(totErrLM2 - totErr2), ...
    abs(totErrLM3 - totErr3), ...
    abs(totErrLM4 - totErr4) ...
    ], 'o-');
title("total reprojection error trend by varying the noise");

% Line plot for the median reprojection errors
figure;
plot(1:4,[ ...
    abs(medianErr1 - medianErrLM1), ...
    abs(medianErr2 - medianErrLM2), ...
    abs(medianErr3 - medianErrLM3), ...
    abs(medianErr4 - medianErrLM4) ...
    ], 'o-');
title("median reprojection error trend by varying the noise");

function [totErr, totErrLM, medianErr, medianErrLM] = compex3(sigmaX, sigmax)
    load("data/compEx3data.mat");

    % 3D plot before LM
    figure;
    plot3(X(1, :), X(2, :), X(3, :), 'b.');
    hold on;
    title("3D reconstruction before and after LM");
    
    % Add the mean-zero gaussian noise to the 3D and 2D points
    % (set std = 0, to not add any noise)
    X = X + arrayfun(@(x) normrnd(0,sigmaX), X);
    x{1} = x{1} + arrayfun(@(x) normrnd(0,sigmax), x{1});
    x{2} = x{2} + arrayfun(@(x) normrnd(0,sigmax), x{2});
    
    errs = ones(1, length(X));
    new_errs = ones(1, length(X));
    Xr = [];
     for j = 1:length(X)
         Xj = X(:, j);
         x1j = x{1}(1:2, j);
         x2j = x{2}(1:2, j);
        
         % compute first reprojection error
         [err, res] = ComputeReprojectionError(P{1}, P{2}, Xj, x1j, x2j);
         errs(j) = err;
    
         % init mu
         mu = 0.01;
    
         % iteratively adjust the error
         for i = 1:50
             [r, J] = LinearizeReprojErr(P{1}, P{2}, Xj, x1j, x2j);
             dj = ComputeUpdate(r, J, mu);
    
             [new_err, res] = ComputeReprojectionError(P{1}, P{2}, Xj + dj, x1j, x2j);
             if new_err < err
                 Xj = Xj + dj;
                 mu = mu / 10;
                 err = new_err;
             else
                mu = mu * 10;
            end
         end
         new_errs(j) = new_err;
         Xr(:, j) = pflat(Xj);
     end
    disp(sum(errs));
    disp(sum(new_errs));
    disp(median(errs));
    disp(median(new_errs));
    totErr = sum(errs);
    totErrLM = sum(new_errs);
    medianErr = median(errs);
    medianErrLM = median(new_errs);
    
    
    % 3D plot before LM
    plot3(Xr(1, :), Xr(2, :), Xr(3, :), 'r.');
    [C1, ~] = camera_center_and_axis(P{1});
            plot_camera(P{1}, 0.4);
            text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
            [C2, ~] = camera_center_and_axis(P{2});
            plot_camera(P{2}, 0.4);
            text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
    legend("3D point before LM", "3D point after LM");
    
    
    % what we observe is that, if the errors are pretty close,
    % we obtained really close 3D plot as well
end

