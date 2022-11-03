function res = randn_circle(x,y,radius,num)
%randn_circle Generate random points inside a circle with normal distribution.
%This code was created by Liang Gaotian in 2022.
%   x：the x-coordinate of the center of the circle
%   y：the y-coordinate of the center of the circle
%   radius：the radius of the circle
%   num：number of points
%   res：Each column is a point

    theta = rand(1,num).*(2*pi);
    [x0,y0] = pol2cart(theta,randn(1,num).*radius/2);
    x0 = x0 + x;
    y0 = y0 + y;
    res = [x0;y0];
end