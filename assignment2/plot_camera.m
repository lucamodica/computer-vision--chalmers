function [] = plot_camera(P, s)
    [C, p_axis] = camera_center_and_axis(P);
    quiver3(C(1),C(2),C(3),p_axis(1),p_axis(2),p_axis(3), s, 'AutoScaleFactor', 3);
end