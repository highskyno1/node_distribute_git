%{
    This code is used to demonstrate the difference in initialization
    methods.
    This code was created by Liang Gaotian in 2022.
%}
close all

num = 500;
radius = 10;
center_x = 0;
center_y = 0;

init1 = rand_square(center_x,center_y,radius,num);
init2 = rand_circle(center_x,center_y,radius,num);
init3 = randn_circle(center_x,center_y,radius,num);

fig = figure(1);
set(fig,'Position',[68,330,1258,450]);
handle = subplot(1,3,1);
scatter(init1(1,:),init1(2,:),'.','LineWidth',10);
hold on
plot_circles(center_x,center_y,radius);
scatter(center_x,center_y,'+','LineWidth',15);
xlabel(sprintf('x/m\n(a) Square Random Initialization'));
ylabel('y/m');
set(handle,'Position',[0.04,0.152,0.2832,0.7]);
set(handle,'LineWidth',1);
set(handle,'FontWeight','Bold');

handle = subplot(1,3,2);
scatter(init2(1,:),init2(2,:),'.','LineWidth',10);
hold on
plot_circles(center_x,center_y,radius);
scatter(center_x,center_y,'+','LineWidth',15);
xlabel(sprintf('x/m\n(b) Circular Random Initialization'));
ylabel('y/m');
set(handle,'Position',[0.3615,0.152,0.2832,0.7]);
set(handle,'LineWidth',1);
set(handle,'FontWeight','Bold');

handle = subplot(1,3,3);
scatter(init3(1,:),init3(2,:),'.','LineWidth',10);
hold on
plot_circles(center_x,center_y,radius);
scatter(center_x,center_y,'+','LineWidth',15);
xlabel(sprintf('x/m\n(c) Circular Normal Distribution Initialization'));
ylabel('y/m');
leg = legend('Initial Position','Reference Circle','Initialization Center');
set(leg,'Position',[0.874,0.856,0.115,0.126]);
set(handle,'xLim',[-radius,radius]);
set(handle,'yLim',[-radius,radius]);
set(handle,'Position',[0.686,0.152,0.2832,0.7]);
set(handle,'LineWidth',1);
set(handle,'FontWeight','Bold');
