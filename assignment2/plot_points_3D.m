function [y] = plot_points_3D(x, markerSize)
  if nargin < 2
      plot3(x(1, :), x(2, :), x(3, :), ' . ', 'MarkerSize', 13)
  else
      plot3(x(1, :), x(2, :), x(3, :), ' . ', 'MarkerSize', markerSize)
  end
