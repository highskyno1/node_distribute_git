%{
    This code shows how the node location planning algorithm works. 
    This code was created by Liang Gaotian in 2022.
%}
close all

% Map boundaries
border = [-500 500];
% Draw the simulated terrain
fig = figure(1);
fsurf(@terrain,border);
xlabel('x/m');
ylabel('y/m');
zlabel('z/m');

% Number of nodes
num_node = 500;
% Number of routers
num_router = 5;
% Number of gateways
gateway_num = 1;
% Maximum number of search points
search_len = 1e2;
% Signal wavelength
lamda = 299792458/(2.44175*1e9);

% Drawing color initialization
rgb_node = zeros(num_router,3);
for i = 1:num_router
    foo = hsv2rgb((i-1)/num_router,1,0.6);
    foo = foo(:)';
    rgb_node(i,:) = foo;
end
rgb_router = zeros(gateway_num,3);
for i = 1:gateway_num
    foo = hsv2rgb((i-1)/gateway_num,1,0.6);
    foo = foo(:)';
    rgb_router(i,:) = foo;
end

% Randomly generate node locations
node_position = rand_circle(0,0,500,num_node);

% Configure the execution properties of the k-means algorithm
options4kmeans = statset('UseParallel',1);
% Execute the k-means algorithm to determine the initial position 
% of the router and its responsible nodes
[belong_router,router_position] = kmeans(node_position',num_router,...
    'Options',options4kmeans,'Display','off');
router_position = router_position';
color_node = zeros(num_node,3);
for i = 1:num_node
    color_node(i,:) = rgb_node(belong_router(i),:);
end

% Draw Router and Node Location Map before optimization
figure(2);
hold on;
fcontour(@terrain,border);
scatter(node_position(1,:),node_position(2,:),15,color_node);
scatter(router_position(1,:),router_position(2,:),'b+','LineWidth',5);
for i = 1:num_router
    text(router_position(1,i),router_position(2,i),['  Cluster Center ',num2str(i)]);
end
hold off;
legend({'Topographic Contour','Terminal','Cluster Center'});
xlabel('x/m');
ylabel('y/m');

tic
% Each router is executed separately
for i_router = 1:num_router
    % Get the location of the node that this router is responsible for
    node_pos_self = node_position(:,belong_router == i_router);
    % Calculate the maximum wireless transmission loss before optimization
    loss_before = pos_fitness4ps0(node_pos_self,router_position(:,i_router),lamda,@terrain,search_len,@KED_fitness);
    fprintf('+++The fitness of Router%d before optimization is:%f\n',i_router,loss_before);
    % Get the center of the initialization algorithm
    center = router_position(:,i_router);
    % Configuring the PSO Algorithm
    options4pso = optimoptions('particleswarm',...
        'UseParallel',true,'MaxStallTime',120,'InitialSwarmMatrix',rand_circle(center(1),center(2),100,20)');
    % Execute the PSO algorithm
    [pos_res,foo] = particleswarm(@(x)...
        (pos_fitness4ps0(node_pos_self,x,lamda,@terrain,search_len,@KED_fitness)),...
        2,[border(1),border(1)],[border(2),border(2)],options4pso);
    router_position_afterPSO(:,i_router) = pos_res';
    fprintf('===The fitness of Router%d after optimization is:%f\n',i_router,foo);
end

% Draw Router and Node Location Map after optimization
figure(3);
hold on;
fcontour(@terrain,border);
scatter(node_position(1,:),node_position(2,:),15,color_node);
scatter(router_position_afterPSO(1,:),router_position_afterPSO(2,:),'b+','LineWidth',5);
hold off;
for i = 1:num_router
    text(router_position_afterPSO(1,i),router_position_afterPSO(2,i),['  Router ',num2str(i)]);
end
legend({'Topographic Contour','Terminal','Cluster Center'});
xlabel('x/m');
ylabel('y/m');

% Stereo version of optimized routing and node locations
figure(4);
colormap(white());
fsurf(@terrain,border);
hold on;
z_node = terrain(node_position(1,:),node_position(2,:));
scatter3(node_position(1,:),node_position(2,:),z_node,15,color_node);
z_router = terrain(router_position_afterPSO(1,:),router_position_afterPSO(2,:));
scatter3(router_position_afterPSO(1,:),router_position_afterPSO(2,:),z_router,'b+','LineWidth',5);
hold off;
legend({'Terrain','Terminal','Cluster Center'});
xlabel('x/m');
ylabel('y/m');

% Determine gateway location
% Use k-means to determine gateway initial location
[belong_gateway,gateway_position] = kmeans(router_position_afterPSO',gateway_num,...
    'Options',options4kmeans,'Display','final','Replicates',10);
gateway_position = gateway_position';
color_router = zeros(num_router,3);
for i = 1:num_router
    color_router(i,:) = rgb_router(belong_gateway(i),:);
end

% Draw the gateway, routers and nodes location diagram before optimization
figure(5);
fcontour(@terrain,border);
hold on;
scatter(node_position(1,:),node_position(2,:),15,color_node);
scatter(router_position_afterPSO(1,:),router_position_afterPSO(2,:),'b+','LineWidth',5);
scatter(gateway_position(1,:),gateway_position(2,:),'r^','LineWidth',5);
hold off;
for i = 1:num_router
    text(router_position_afterPSO(1,i),router_position_afterPSO(2,i),['  Router ',num2str(i)]);
end
legend({'Terrain','Terminal','Router','Cluster Center'});
xlabel('x/m');
ylabel('y/m');

for i_gateway = 1:gateway_num
    % Get the routers that this gateway is responsible for
    router_pos_self = router_position_afterPSO(:,belong_gateway == i_gateway);
    % Calculate the maximum wireless transmission loss before optimization
    loss_before = pos_fitness4ps0(router_pos_self,gateway_position(:,i_gateway),lamda,@terrain,search_len,@KED_fitness);
    fprintf('+++The fitness of gateway%d before optimization is:%f\n',i_gateway,loss_before);
    % Get the center of the initialization algorithm
    center = gateway_position(:,i_gateway);
    % Execution configuration of the PSO algorithm
    options4pso = optimoptions('particleswarm',...
        'UseParallel',true,'MaxTime',120,'InitialSwarmMatrix',rand_circle(center(1),center(2),100,20)');
    % Calculate optimal gateway location using PSO
    [pos_res,foo] = particleswarm(@(x)...
        (pos_fitness4ps0(router_pos_self,x,lamda,@terrain,search_len,@KED_fitness)),...
        2,[border(1),border(1)],[border(2),border(2)],options4pso);
    gateway_position(:,i_gateway) = pos_res';
    fprintf('===The fitness of gateway%d after optimization is:%f\n',i_gateway,foo);
end
toc

% Draw the gateway, routers and nodes location diagram after optimization
figure(6);
fcontour(@terrain,border);
hold on;
scatter(node_position(1,:),node_position(2,:),15,color_node);
scatter(router_position_afterPSO(1,:),router_position_afterPSO(2,:),'b+','LineWidth',5);
scatter(gateway_position(1,:),gateway_position(2,:),'r^','LineWidth',5);
hold off;
for i = 1:num_router
    text(router_position_afterPSO(1,i),router_position_afterPSO(2,i),['  Gateway ',num2str(i)]);
end
legend({'Terrain','Terminal','Router','Gateway'});
xlabel('x/m');
ylabel('y/m');
