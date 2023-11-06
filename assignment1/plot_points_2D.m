function [y] = plot_points_2D(x, color)
  if nargin < 2
      plot(x(1, :), x(2, :), '.', 'MarkerSize', 9);
  else
      plot(x(1, :), x(2, :), '.', 'MarkerSize', 9, 'Color', color);
  end