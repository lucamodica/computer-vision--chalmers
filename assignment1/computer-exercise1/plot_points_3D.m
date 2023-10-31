function [y] = plot_points_3D(x);
  plot3(x(1, :), x(2, :), x(3, :), ' . ', 'MarkerSize', 13)
