function [C, p_axis] = camera_center_and_axis(P)
    C = pflat(null(P));
    p_axis = pflat(P(3 ,1:3).');