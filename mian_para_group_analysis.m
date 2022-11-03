%{
    This code is used to plot and compare the effect of different parameter
    groups on PSO performance.
    This code was created by Liang Gaotian in 2022.
%}
base_path = './author_exc_res';
g1 = load(fullfile(base_path,'Parameter group 1_100 time tests.mat'));
g2 = load(fullfile(base_path,'Parameter group 2_100 time tests.mat'));
g3 = load(fullfile(base_path,'Parameter group 3_100 time tests.mat'));

timespend = [g1.time_rec',g2.time_rec',g3.time_rec'];

fig = figure(1);
color = hsv(14);
color = color(end-4:end,:);
boxplot(timespend,{'Group 1','Group 2','Group 3'},'colors',color);
xlabel('Parameter Group')
for i = 1:3
    foo = mean(timespend(:,i));
    text(i-0.035,foo,'X','Color',color(i,:));
end
ylabel('Time Consumption(s)');
set(fig.CurrentAxes,'FontWeight','bold');
set(fig.CurrentAxes,'Position',[0.0909,0.1088,0.8856,0.8678]);
set(fig.Children(1),'FontWeight','bold');

effect = [mean(g1.fitness_router_rec,2),mean(g2.fitness_router_rec,2),mean(g3.fitness_router_rec,2)]';
effect = [effect,[mean(g1.fitness_gateway_rec);mean(g2.fitness_gateway_rec);mean(g3.fitness_gateway_rec);]];
fig = figure(2);
x = categorical({'Group 1','Group 2','Group 3'});
bar(x,effect,'BarWidth',1);
xlabel('Parameter Group');
ylabel('Mean Maximum Transmission Loss(dB)');
legend({'Router 1','Router 2','Router 3','Router 4','Router 5','Gateway',});
set(fig.CurrentAxes,'ylim',[0,160]);
set(fig.CurrentAxes,'FontWeight','bold');
set(fig.CurrentAxes,'Position',[0.1035,0.11,0.8714,0.8661]);
