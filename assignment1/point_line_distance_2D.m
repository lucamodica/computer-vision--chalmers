function [d] = point_line_distance_2D(p, l)
  % Compute the distance between a point (p) and a line (l)
  d = abs(l(1)*p(1) + l(2)*p(2) + l(3)) / sqrt(l(1)^2 + l(2)^2);