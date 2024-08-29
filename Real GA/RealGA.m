clc
clear all
close all

%% GA parameters

npop = 1000;
ngen = 10000;
m = 0; % minimization problem: 0 or maximization problem: 1
id = repmat([0; 2.5], [1, 13]);
nvar = size(id, 2); % number of variables
ncr = nvar; % each cromosome length
pc = 0.8; % probability of crossover
pm = 0.3; % probability of mutation
landa = 0.2;
mu = 0.2;
%A = 100;
%B = 1;

docrossover = @(x1, x2) realcrossover(x1, x2, landa, id);
domutation = @(x) realmutation(x, mu, id);
costfunction = @(x) myfun4(x);

%% Create initial population

initpop = zeros(npop, ncr+1);
initpop(:, 1:end-1) = createrandomsolution (npop, id);
initpop(:, end) = costfunction(initpop(:, 1:end-1));

% global NFE
% NFE = 0;
% nfe = zeros(1, ngen);

%% main loop

bestsol = zeros(ngen, ncr+1);
i = 0;
j = zeros(1, 3);
n = 0;

for i = 1:ngen
    
    % plot3(initpop(:, 1), initpop(:, 2), initpop(:, 3), 'o');
    % axis([-6 6 -6 6 -6 6]);
    % M(i) = getframe;

    % do crossover
    crosspop = zeros(size(initpop));
    jx = 0;
    for ix = 1:npop/2
        a = rand;
        if a < pc
            jx = jx + 2;
            c1 = roulettewheel(initpop(:, end), m);
            c2 = roulettewheel(initpop(:, end), m);
            x1 = initpop(c1, 1:end-1);
            x2 = initpop(c2, 1:end-1);
            [y1, y2] = docrossover(x1, x2);
            crosspop(jx-1, 1:end-1) = y1;
            crosspop(jx, 1:end-1) = y2;
        end
    end
    crosspop(jx+1:end, :)=[];
    crosspop(:, end) = costfunction(crosspop(:, 1:end-1));
    
    % do mutation
    mutpop = zeros(size(initpop));
    jm = 0;
    for im = 1:npop
        b = rand;
        if b < pm
            jm = jm+1;
            c = roulettewheel(initpop(:, end), m);
            x = initpop(c, 1:end-1);
            y = domutation(x);
            mutpop(jm, 1:end-1) = y;
        end
    end
    mutpop(jm+1:end, :)=[];
    mutpop(:, end) = costfunction(mutpop(:, 1:end-1));
    
    % going to next generation
    pop = zeros(npop, ncr+1);
    pop(1:jx, :) = crosspop;
    
    if jx+jm <= npop
        
        pop(jx+1:jx+jm, :) = mutpop;
        
        for ii = 1:npop-(jx+jm)
           f = roulettewheel(initpop(:, end), m);
           pop(jx+jm+ii, :) = initpop(f, :);
        end
        
    else
        
        for jj = 1:npop-jx
           f = roulettewheel(mutpop(:, end), m);
           pop(jx+jj, :) = mutpop(f, :);
        end
        
    end
    
    % save elite cromosome
    if m == 0
        [~, w] = max(pop(:, end));
    else
        [~, w] = min(pop(:, end));
    end
    pop(w, :) = pickelite(initpop, crosspop, mutpop, m);
    initpop = pop;
    
    if m == 0
        [~, b] = min(pop(:, end));
    else
        [~, b] = max(pop(:, end));
    end
    
    % nfe(i) = NFE;
    bestsol(i, :) = pop(b, :);
   
    
    bestcost = bestsol(i, end);
    fprintf('generation: %g, bestcost: %g \n', i, bestcost);
end

%% showing the results

plot(1:size(bestsol, 1), bestsol(:, end), 'LineWidth', 2);
% plot(nfe, bestsol(:, end));