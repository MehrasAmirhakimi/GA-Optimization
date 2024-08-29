clc
clear all
close all

%% GA parameters

npop = 250;
ngen_ini = 400;
alpha = 0.3;
m = 0; % minimization problem: 0 or maximization problem: 1
id = [15, 15, 15, 15; -5, -5, -5, -5; 5, 5, 5, 5];
nvar = size(id, 2); % number of variables
ncr = sum(id(1, :)); % each cromosome length
pc = 0.85; % probability of crossover
pm = 0.1; % probability of mutation
cross_p = [0.7, 0.15, 0.15];
mu = 0.1;
fa = 5;
fb = 0.05;
fc = 4*pi;

parse = @(x) parsepop(x, id);
docrossover = @(x1, x2) crossover(x1, x2, cross_p);
domutation = @(x) mutation(x, mu);
costfunction = @(x) Ackley(x, fa, fb, fc);

%% Create initial population

initpop = randi([0 1], [npop, ncr+1]);
ppop = parse(initpop);
initpop(:, end) = costfunction(ppop);

% global NFE
% NFE = 0;
% nfe = zeros(1, ngen);

%% main loop

bestsol = zeros(ngen_ini, ncr+1);
i = 0;
j = zeros(1, 3);
n = 0;

while n == 0;
    
    i = i+1;

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
    pcrosspop = parse(crosspop);
    crosspop(:, end) = costfunction(pcrosspop);
    
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
    pmutpop = parse(mutpop);
    mutpop(:, end) = costfunction(pmutpop);
    
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
   
    % pause condition
    
    if i < 2 * ngen_ini
        n = 0;
    elseif bestsol(i, end) - bestsol(i-1, end) ~= 0
        j(1) = 0;
    else
        j(1) = j(1)+1;
    end
    
    if j(1) > alpha * ngen_ini
        pc = 0.6;
        pm = 0.4;
        cross_p = [0.5, 0.3, 0.2];
        mu = 0.1;
        j(2) = j(2)+1;
    else
        pc = 0.8;
        pm = 0.1;
        cross_p = [0.7, 0.15, 0.15];
        mu = 0.1;
    end
    
    if j(2) > ngen_ini
        j(1) = 0;
        j(3) = j(3) + 1;
    end
    
    if j(3) > 2 * ngen_ini
        n = 1;
    end
    
    bestcost = bestsol(i, end);
    fprintf('generation: %g, bestcost: %g \n', i, bestcost);
end

%% showing the results

plot(1:size(bestsol, 1), bestsol(:, end), 'LineWidth', 2);

fprintf('best solution is: \n');
parse(bestsol(end, :))