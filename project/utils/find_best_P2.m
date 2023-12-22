function [P2, X] = find_best_P2(E, x1n, x2n, P1, K, inliersIdxs)
    % compute the 4 cameras to choose P2
    cameras = extract_P_from_E(E);
    P2 = [];
    X = [];
    bestFrontCount = 0;

    for i = 1:4
        Xt = pflat(triangulate_3D_point_DLT(x1n, x2n, P1, cameras{i}));
        Xt = Xt(:, inliersIdxs);
        xtP1 = P1 * Xt;
        xtP2 = cameras{i} * Xt;

        % 3D plot
        %{
        P2u = K * cameras{i};
        P1u = K * P1;
        figure;
        plot3(Xt(1, :), Xt(2, :), Xt(3, :), 'b.');
        hold on;
        [C1, ~] = camera_center_and_axis(P1u);
        plot_camera(P1, 0.4);
        text(C1(1), C1(2), C1(3), 'C1', 'FontSize', 12, 'HorizontalAlignment', 'right');
        [C2, ~] = camera_center_and_axis(P2u);
        plot_camera(cameras{i}, 0.4);
        text(C2(1), C2(2), C2(3), 'C2', 'FontSize', 12, 'HorizontalAlignment', 'right');
        title("3D reconstruction of the building with P1 and extracted camera " + i);
        %}

        frontCount = sum(xtP1(3,:) > 0) + sum(xtP2(3,:) > 0);
        if frontCount > bestFrontCount
            bestFrontCount = frontCount;
            X = Xt;
            P2 = cameras{i};
        end
    end
