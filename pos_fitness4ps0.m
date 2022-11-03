function res = pos_fitness4ps0(node_loc,pos_loc,lamda,terrain,search_len,fitness_fun)
%pos_fitness4ps0 The fitness calculation function encapsulated for calling the optimization algorithm.
%This code was created by Liang Gaotian in 2022.
%   node_loc: Node location
%   pos_loc: Particle position
%   lamda：Wavelength
%   terrain：Terrain description function
%   search_len：Maximum search length
%   fitness_fun：Fitness calculation function

    res = 0;
    [~,node_size] = size(node_loc);
    for i = 1:node_size
        foo = fitness_fun(node_loc(:,i),pos_loc,lamda,terrain,search_len);
        if res < foo
            res = foo;
        end
    end
end

