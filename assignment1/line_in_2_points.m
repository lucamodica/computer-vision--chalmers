function [l] = line_in_2_points(x1, x2)
    l = polyfit([x1(1), x2(1)], [x1(2), x2(2)], 1);