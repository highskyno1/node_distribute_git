function res = rand_square(center_x,center_y,radius,num)
%rand_square Initialize points inside a square
%This code was created by Liang Gaotian in 2022.
%   x：the x-coordinate of the center of the circle
%   y：the y-coordinate of the center of the circle
%   radius：Radius of the inscribed circle
%   num：number of points
%   res：Each column is a point

    res = 2.*rand(2,num) - 1;
    res = res .* radius;
    res(1,:) = res(1,:) + center_x;
    res(2,:) = res(2,:) + center_y;
end