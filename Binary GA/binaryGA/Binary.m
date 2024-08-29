clc
clear all
close all

%% GA parameters

npop = 250;
ngen = 500;
m = 0; % minimization problem: 0 or maximization problem: 1
id = [15, 15, 15, 15; -5, -5, -5, -5; 5, 5, 5, 5];
nvar = size(id, 2); % number of variables
ncr = sum(id(1, :)); % each cromosome length
pc = 0.8; % probability of crossover
pm = 0.1; % probability of mutation
sdu = [0.7, 0.15, 0.15];
mu = 0.1;
fa = 1;
fb = 0.1;
fc = 2*pi;

parse = @(x) parsepop(x, id);
docrossover = @(x1, x2) crossover(x1, x2, sdu);
domutation = @(x) mutation(x, mu);
costfunction = @(x) Ackley(x, fa, fb, fc);

%% Create initial population

initpop = zeros(npop, ncr+1);
initpop(:, 1:ncr) = randi([0 1], [npop, ncr]);
ppop = parse(initpop);
initpop(:, end) = costfunction(ppop);

%% main loop

bestsol = zeros(ngen, ncr+1);
i = 0;
j = zeros(1, 3);
n = 0;

for i = 1:ngen
    
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
    
    bestsol(i, :) = pop(b, :);
    bestcost = bestsol(i, end);
    fprintf('generation: %g, bestcost: %g \n', i, bestcost);

end

%% showing the results

plot(1:size(bestsol, 1), bestsol(:, end), 'LineWidth', 2);
fprintf('best solution is: \n');
parse(bestsol(end, :))