function J = KED_fitness(pos_1,pos_2,lamda,terrain,search_len)
%KED_fitness KED Diffraction Loss Model
%   This code was created by Liang Gaotian in 2022.
%   pos_1：Position 1
%   pos_2：Position 2
%   lamda：Wavelength
%   terrain：Terrain Description Function
%   return J：Diffraction loss (dB) under KED model (positive number)

    d = ((pos_2(1)-pos_1(1))^2 + (pos_2(2)-pos_1(2))^2)^0.5;
    % Calculate free transmission loss
    Lfs = poslin(20*log10(4*pi*d/lamda));
    z1 = terrain(pos_1(1),pos_1(2));
    z2 = terrain(pos_2(1),pos_2(2));
    % Find the maximum value (peak) between two points
    x = linspace(pos_1(1),pos_2(1),search_len);
    y = linspace(pos_1(2),pos_2(2),search_len);
    z = terrain(x,y);
    % Calculate the difference
    z_diff = diff(z);
    for i = 2:search_len-1
        if z_diff(i) < 0 && z_diff(i-1) > 0
            z_max = z(i);
            x_max = x(i);
            y_max = y(i);
            J = diffraction_cal(z1,z2,z_max,x_max,y_max,pos_1,pos_2,lamda) + Lfs;
            return
        end
    end
    % There is no diffraction loss between the given two points
    J = Lfs;
end

function J = diffraction_cal(z1,z2,z_max,x_max,y_max,pos_1,pos_2,lamda)
%diffraction_cal Calculate the Diffraction Loss between two points
%   z1: height of endpoint 1
%   z2: height of endpoint 2
%   z_max: Z coordinate of the top of the peak
%   x_max: X coordinate of the top of the peak
%   y_max: Y coordinate of the top of the peak
%   pos_1: an array like [x,y] representing the 2D coordinates of endpoint 1
%   pos_2: an array like [x,y] representing the 2D coordinates of endpoint 2
%   lamda: Wavelength
%   return J：Diffraction loss (dB)

% Calculate Fresnel integral parameters
pos_z_max = max([z1,z2]);
h = pos_z_max - z_max;
d1 = ((x_max - pos_1(1))^2 + (y_max - pos_1(2))^2 + h^2)^0.5;
d2 = ((x_max - pos_2(1))^2 + (y_max - pos_2(2))^2 + h^2)^0.5;
v = h*(2/lamda*(1/d1+1/d2))^0.5;
if v > -0.78
    % Satisfy the condition, use the simplified formula
    J = 6.9 + 20*log10(((v - 0.1)^2 + 1)^0.5 + v - 0.1);
else
    % Instead, use the definition
    Cv = fresnelc(v);
    Sv = fresnels(v);
    foo = (((1 - Cv -Sv)^2 + (Cv - Sv)^2)^0.5)/2;
    J = -20*log10(foo);
end
end
