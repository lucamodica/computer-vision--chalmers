function [e] = e_RMS(points_meas, points_proj)
    n = length(points_proj);
    dx = points_meas - points_proj;
    e = sqrt((1/n) * norm(dx,'fro').^2);
   