camera_res = 800 * 600;

K = [
    400, 0, 400;
    0, 400, 300;
    0, 0, 1
];

x_1 = [0; 300; 1];
x_2 = [800; 300; 1];

x_1_norm = inv(K) * x_1;
x_2_norm = inv(K) * x_2;

angle = asin(x_1_norm.' * x_2_norm);