close all;
clear;

syms t1 t2 t3 

t = [t1;t2;t3];

t_skew = [0 -t3 t2;
          t3 0 -t1;
         -t2 t1 0 ];


[vec,val] = eig(t_skew.' * t_skew);

%val =
% [0,                  0,                  0]
% [0, t1^2 + t2^2 + t3^2,                  0]
% [0,                  0, t1^2 + t2^2 + t3^2]


[U, S, V] = svd(t_skew);