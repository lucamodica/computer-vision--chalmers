function [F] = convert_E_to_F(E, K1, K2)
    F = inv(K2.') * E * inv(K1);