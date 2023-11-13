function [d] = depth(plane, point)
  d = -plane(1:3).' * point;