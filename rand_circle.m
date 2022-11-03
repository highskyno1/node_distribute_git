function res = rand_circle(x,y,radius,num)
%rand_circle Generate random points with circular distribution
%This code was created by Liang Gaotian in 2022.
%   x£ºthe x-coordinate of the center of the circle
%   y£ºthe y-coordinate of the center of the circle
%   radius£ºthe radius of the circle
%   num£ºnumber of points
%   res£ºEach column is a point

    theta = rand(1,num).*(2*pi);
    [x0,y0] = pol2cart(theta,rand(1,num).*radius);
    x0 = x0 + x;
    y0 = y0 + y;
    res = [x0;y0];
end

