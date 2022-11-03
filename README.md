本文件的中文版本请见main下的“读我.md”。
# Welcome
This is the public code of an SCI paper of the author. After the paper is accepted and published, I will upload the relevant information of the paper. 
# Foreword
`Any use, copying, modification, derivation, or distribution of this code must indicate the source!`
This code is used to test the time consumption and performance of the node deployment location planning algorithm. Based on the terrain description function, the algorithm designs a reasonable objective function under the premise of considering the free space of electromagnetic waves and diffraction loss. The k-means and PSO algorithms are used to optimize the location of routers and gateways, and the GA algorithm is introduced as a comparison. For details on this code, see Sections 4.1 and 4.2 of the paper. 
# How to execute this code?
The author wrote this code based on ==MATLAB R2021b==, and does not guarantee the stability of other MATLAB versions. Therefore, it is recommended to use MATLAB R2021b or later to run this project.
# File Description
## Directly Executable File
The code of this project has a total of 5 files that can be directly executed, and these files are named in the format of "main_xxx.m". These files are described below: 
- main_deno.m: This code shows how the planning algorithm works.
- main_ga.m: This code is used to evaluate the time and effect required by the GA to solve the node planning problem.
- main_pso.m: This code is used to evaluate the time and effect required by the PSO algorithm to solve the node planning problem.
- main_plot_init_method.m: This code uses the drawing method to demonstrate three different particle initialization methods.
- main_para_gooup_analysis.m: This code is used to plot and compare the effects of different parameter groups on the performance of the PSO algorithm, as shown in Figure 9 and Figure 10 in Section 4.1 of the paper.
- main_ga_pso_analysis.m: This code is used to plot and compare the performance of the PSO and GA algorithms. 
## Function File
- KED_fitness.m: KED loss calculation model.
- plot_circles.m: Draw a circle in the figure. 
- pos_fitness4ps0.m: The fitness calculation function encapsulated for calling the optimization algorithm.
- terrain.m: Terrain description function. 
## Particle Initialization Method
The initialization method can be better understood by executing the "main_plot_init_method.m" file. 
- rand_circle.m: Generate random points with circular distribution. 
- rand_square.m: Initialize points inside a square. 
- randn_circle.m: Generate random points inside a circle with normal distribution. 
# Folder Description
- author_exc_res: The results of the author's operation are placed in this folder. Directly running "main_para_gooup_analysis.m" or "main_ga_pso_analysis.m" calls the data in this folder, and can draw the same data graph as the paper.
# Modifiable Parameters
The modifiable parameters of the "main_deno.m", "main_ga.m" and "main_pso.m" files are as follows: 
- num_node: Number of nodes
- num_router: Number of routers
- gateway_num: Number of gateways
- search_len: The number of mountain search steps, a larger value can obtain a more accurate mountain position, but the execution time will be longer; a smaller value will result in lower accuracy, but can speed up code execution.
- lamda: Electromagnetic Wavelength (m)
## Modify the Particle Initialization Method
The particle initialization methods can be selected as: square distribution, circular distribution and circular normal distribution, and the corresponding initialization function names are "rand_square", "rand_circle", "randn_circle" respectively. If you need to modify the initialization method, please find the configuration code of the PSO or GA method, similar to the following code snippet:
```MATLAB
% Execution configuration of the PSO algorithm
options4pso = optimoptions('particleswarm',...
            'UseParallel',true,'MaxStallTime',120, ...
            'inertia',[0,0.1],'SelfAdjustmentWeight',1.49, ...
            'SocialAdjustmentWeight',1.49,... % 'SwarmSize',20);
            'InitialSwarmMatrix',rand_circle(center(1),center(2),100,20)');
            
% Execution configuration of the GA
options4ga = optimoptions('ga','Display','diagnose','UseParallel',true, ...
    'MaxStallTime',120, ... 'PopulationSize',20);
    'InitialPopulationMatrix',rand_circle(center(1),center(2),100,20)');
```
Modify the initialization function followed by the "InitialPopulationMatrix" property to another function.
