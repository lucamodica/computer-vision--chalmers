function [y] = pflat(x)
  % takes as input an array of shape (m,n),
  % representing n points in P^{m−1} in homogeneous 
  % coordinates, and get an (m,n)-array containing 
  % the same homogeneous points but where each point 
  % is normalized so that its last coordinate is 1
  % INPUT : 
  %  x     - matrix in which each column is a point.
  % OUTPUT :
  %  y     - (m,n)-array containing the same homogeneous
  %          points, but where each point is normalized 
  %          so that its last coordinate is 1
  y = x ./ x(end,:);
end