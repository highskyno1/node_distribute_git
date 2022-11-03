%{
    This code is used to evaluate the time consumption and effect of 
    the GA optimization algorithm to solve the planning problem. 
    This code was created by Liang Gaotian in 2022.
%}
close all

% Map boundaries
border = [-500 500];
% Draw the simulated terrain
figure;
fsurf(@terrain,border);
xlabel('x/m');
ylabel('y/m');
zlabel('z/m');
% Force drawing
drawnow;

% Number of nodes
num_node = 100;
% Number of routers
num_router = 5;
% Number of gateways
gateway_num = 1;
% Maximum number of search points
search_len = 1e2;
% Signal wavelength
lamda = 299792458/(2.44175*1e9);
% Algorithm test times
test_time = 1;

% Randomly generate node locations
node_position = rand_circle(0,0,500,num_node);

% Configure the execution properties of the k-means algorithm
options4kmeans = statset('UseParallel',true);
% Execute the k-means algorithm to determine the initial position 
% of the router and its responsible nodes
[belong_router,router_position] = kmeans(node_position',num_router,...
    'Options',options4kmeans,'Display','off');
router_position = router_position';

% Zero-initialized result record matrixess
time_rec = zeros(1,test_time);
fitness_router_rec = zeros(num_router,test_time);
fitness_gateway_rec = zeros(gateway_num,test_time);
for times_ind = 1:test_time
    % Timing start point
    tic
    % Zero-initialized temporary matrixess
    time_spend = zeros(1,5);
    router_position_afterPSO = zeros(2,num_router);
    % Each router is executed separately
    for i_router = 1:num_router
        % Get the location of the node that this router is responsible for
        node_pos_self = node_position(:,belong_router == i_router);
        % Calculate the maximum wireless transmission loss before optimization
        loss_before = pos_fitness4ps0(node_pos_self,router_position(:,i_router),lamda,@terrain,search_len,@KED_fitness);
        % Get the center of the initialization algorithm
        center = router_position(:,i_router);
        % Execution configuration of the GA
        %{
            If you need to test other initialization methods of the GA, 
            please modify the following code.
            DON'T forget to synchronously modify the GA configuration for
            the gateway below. 
        %}
        options4ga = optimoptions('ga','Display','diagnose','UseParallel',true, ...
            'MaxStallTime',120, ... 'PopulationSize',20);
            'InitialPopulationMatrix',rand_circle(center(1),center(2),100,20)');

        % Execute the GA
        [pos_res,foo] = ga(@(x)...
            (pos_fitness4ps0(node_pos_self,x,lamda,@terrain,search_len,@KED_fitness)),...
            2,[],[],[],[],[border(1),border(1)],[border(2),border(2)],[],options4ga);
        % Record the optimized fitness
        router_position_afterPSO(:,i_router) = pos_res';
        fitness_router_rec(i_router,times_ind) = foo;
    end

    % The following code is used to determine the location of the gateway
    % Use k-means to determine gateway initial location
    [belong_gateway,gateway_position] = kmeans(router_position_afterPSO',gateway_num,...
        'Options',options4kmeans,'Display','final','Replicates',10);
    gateway_position = gateway_position';

    % Execute separately for each gateway
    for i_gateway = 1:gateway_num
        % Get the routers that this gateway is responsible for
        router_pos_self = router_position_afterPSO(:,belong_gateway == i_gateway);
        % Calculate the maximum wireless transmission loss before optimization
        loss_before = pos_fitness4ps0(router_pos_self,gateway_position(:,i_gateway),lamda,@terrain,search_len,@KED_fitness);
        fprintf('+++优化前网关%d的适应度为:%f\n',i_gateway,loss_before);
        % Get the center of the initialization algorithm
        center = gateway_position(:,i_gateway);
        % Execution configuration of the GA
        %{
            If you need to test other initialization methods of the GA, 
            please modify the following code.
            DON'T forget to synchronously modify the GA configuration for
            the router above. 
        %}
        options4ga = optimoptions('ga','Display','diagnose','UseParallel',true, ...
            'MaxStallTime',120, ...'PopulationSize',20);
            'InitialPopulationMatrix',rand_circle(center(1),center(2),100,20)');
        
        % Calculate optimal gateway location using PSO
        [pos_res,foo] = ga(@(x)...
            (pos_fitness4ps0(node_pos_self,x,lamda,@terrain,search_len,@KED_fitness)),...
            2,[],[],[],[],[border(1),border(1)],[border(2),border(2)],[],options4ga);
        gateway_position(:,i_gateway) = pos_res';
        
        % Record the optimized fitness
        fitness_gateway_rec(i_gateway,times_ind) = foo;
    end
    % Timing end point, record the time-consuming of this execution
    time_rec(times_ind) = toc;
    % Let me know if this code is executing correctly
    fprintf("!!!The %d-th execution took %f seconds!!!\n",times_ind,time_rec(times_ind));
end
% Save the execution result to a file.
if ~exist('./exc_res/','dir')
    mkdir('./exc_res');
end
% REMEMBER to use different file names for different parameters.
save('./exc_res/GA_rand_circle_1.mat',"fitness_router_rec","fitness_gateway_rec","time_rec");
