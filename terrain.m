function res = terrain(x,y)
%terrain Terrain Description Function
%This code was created by Liang Gaotian in 2022.
% x: Plane coordinate x
% y: Plane coordinate y

    x_s = x/100;
    y_s = y/100;
    x_t = x/50;
    y_t = y/50;
    res = 0.1*peaks(0.5*y_s+3,0.7*x_s+1) - 0.2*peaks(0.3*x_s+0.2,0.2*y_s-0.2) + 0.4 * peaks(0.7*y_s-0.3,0.8*x_s-0.3);
    res = res*10 + 0.7*inner_terrain(0.2*x_t-1,0.5*y_t-1);
    res = res * 10;
end

function res = inner_terrain(x,y)
%inner_terrain Internal terrain description function
% x: Plane coordinate x
% y: Plane coordinate y

    res = 0.5*exp(-(0.8*x-1).^2-(0.9*y-2).^2) + ...
        0.3*exp(-(0.4*x+2).^2-(0.6*y+3).^2) + ...
        0.6*exp(-(0.7*x+3).^2-(0.5*y-4).^2);
    res = res * 100;
end