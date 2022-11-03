function plot_circles(CenterX,CenterY,radius)
%plot_circles Draw a circle in the figure
%This code was created by Liang Gaotian in 2022.
%   CenterX: the x-coordinate of the center of the circle
%   CenterY: the y-coordinate of the center of the circle
%   radius: the radius of the circle

    angles = linspace(0, 2*pi, 500);
    x = radius * cos(angles) + CenterX;
    y = radius * sin(angles) + CenterY;
    plot(x, y, '--', 'LineWidth', 2);
end