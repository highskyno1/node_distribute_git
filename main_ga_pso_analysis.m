%{
    This code is used to plot and compare the performance of GA and PSO.
    This code was created by Liang Gaotian in 2022.
%}
base_path = './author_exc_res';
ga1 = load(fullfile(base_path,'GA_square_100_time_tests.mat'));
ga2 = load(fullfile(base_path,"GA_circle_100_time_tests.mat"));
ga3 = load(fullfile(base_path,'GA_circle_nor_100_time_tests.mat'));

pso1 = load(fullfile(base_path,'PSO_square_100_time_tests.mat'));
pso2 = load(fullfile(base_path,'PSO_circle_100_time_tests.mat'));
pso3 = load(fullfile(base_path,'PSO_circle_nor_100_time_tests.mat'));

timespend = [ga1.time_rec',ga2.time_rec',ga3.time_rec', ...
    pso1.time_rec',pso2.time_rec',pso3.time_rec'];

fig = figure(1);
color = hsv(16);
color = color(end-6:end,:);
boxplot(timespend,{'GA_a','GA_b','GA_c','PSO_a','PSO_b','PSO_c'},'colors',color,'Widths',0.5);
for i = 1:6
    foo = mean(timespend(:,i));
    text(i-0.0455,foo,'X','Color',color(i,:));
end
ylabel('Time Consumption(s)');
set(fig.CurrentAxes,'FontWeight','bold');
set(fig.CurrentAxes,'LineWidth',1);
set(fig.CurrentAxes,'Position',[0.0909,0.1088,0.8856,0.8678]);
set(fig.Children(1),'FontWeight','bold');


effect = [mean(ga1.fitness_router_rec,2),mean(ga2.fitness_router_rec,2),mean(ga3.fitness_router_rec,2), ...
    mean(pso1.fitness_router_rec,2),mean(pso2.fitness_router_rec,2),mean(pso3.fitness_router_rec,2)]';
effect = [effect,[mean(ga1.fitness_gateway_rec);mean(ga2.fitness_gateway_rec);mean(ga3.fitness_gateway_rec); ...
    mean(pso1.fitness_gateway_rec);mean(pso2.fitness_gateway_rec);mean(pso3.fitness_gateway_rec)]];
fig = figure(2);
x = categorical({'GA\_a','GA\_b','GA\_c','PSO\_a','PSO\_b','PSO\_c'});
bar(x,effect,'stacked','BarWidth',1);
ylabel('Mean Maximum Transmission Loss(dB)');
legend({'Router 1','Router 2','Router 3','Router 4','Router 5','Gateway',});
set(fig.CurrentAxes,'ylim',[0,800]);
set(fig.CurrentAxes,'FontWeight','bold');
set(fig.CurrentAxes,'LineWidth',1);
set(fig.CurrentAxes,'Position',[0.1035,0.11,0.8714,0.8661]);
