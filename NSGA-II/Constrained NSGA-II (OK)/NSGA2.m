clc
clear all
close all

%% GA parameters

npop = 100;
ngen = 100;
m = [0, 0]; % minimization problem: 0 or maximization problem: 1
id = repmat([0; pi], [1, 2]);
nvar = size(id, 2); % number of variables
ncr = nvar; % each cromosome length
pc = 0.8; % probability of crossover
pm = 0.1; % probability of mutation
landa = 0.1;
mu = 0.5;
nobj = numel(m);
% cons = [-1, -1, -1; 250 * 10^6 , 0.02, 1000];

docrossover = @(x1, x2) realcrossover(x1, x2, landa, id);
domutation = @(x) realmutation(x, mu, id);
costfunction = @(x) Tanaka(x);

%% Initialization

% creating initial population
initpop = zeros(npop, ncr + nobj + 6);
initpop(:, 1 : ncr) = createrandomsolution (npop, id);

% calculating objective functions
obj = costfunction(initpop(:, 1 : ncr));
initpop(:, ncr + 1 : ncr + nobj) = obj;

% calculating feasibility and violation of solutions
% [isfeasible, sumviols] = constraintchecker(obj, cons);
[isfeasible, sumviols] = TanakaCC(initpop(:, 1:ncr));
initpop(:, ncr + nobj + 5 : end) = [isfeasible, sumviols];

% non-constraind and constrained fronting
fc = front(initpop(isfeasible == 1, ncr + 1 : ncr + nobj), m);
initpop(isfeasible == 1, ncr + nobj + 3) = fc(:, 2);

% calculating non-constraind and constrained crowding distance
cdc = crowdingdistance(initpop(isfeasible == 1, ncr + 1 : ncr + nobj), fc, m);
initpop(isfeasible == 1, ncr + nobj + 4) = cdc;

nInitpop = zeros(ngen, 1);

%% main loop

figure

for i = 1:ngen

    % do crossover
    
    crosspop = zeros(size(initpop));
    jx = 0;
    for ix = 1:npop/2
        a = rand;
        if a < pc
            jx = jx + 2;
            c1 = cbinaryts(initpop(:, ncr + nobj + 3 : end));
            c2 = cbinaryts(initpop(:, ncr + nobj + 3 : end));
            x1 = initpop(c1, 1 : ncr);
            x2 = initpop(c2, 1 : ncr);
            [y1, y2] = docrossover(x1, x2);
            crosspop(jx-1, 1 : ncr) = y1;
            crosspop(jx, 1 : ncr) = y2;
        end
    end
    crosspop(jx+1 : end, :)=[];
    crosspop(:, ncr + 1 : ncr + nobj) = costfunction(crosspop(:, 1 : ncr));
    
    % do mutation
    
    mutpop = zeros(size(initpop));
    jm = 0;
    for im = 1:npop
        b = rand;
        if b < pm
            jm = jm+1;
            c = cbinaryts(initpop(:, ncr + nobj + 3 : end));
            x = initpop(c, 1 : ncr);
            y = domutation(x);
            mutpop(jm, 1 : ncr) = y;
        end
    end
    mutpop(jm+1 : end, :)=[];
    mutpop(:, ncr + 1 : ncr + nobj) = costfunction(mutpop(:, 1 : ncr));
    
    % going to next generation
    
    pop = [initpop; crosspop; mutpop];
    
    obj = pop(:, ncr + 1 : ncr + nobj);
    % [isfeasible, sumviols] = constraintchecker(obj, cons);
    [isfeasible, sumviols] = TanakaCC(pop(:, 1:ncr));
    pop(:, ncr + nobj + 5 : end) = [isfeasible, sumviols];
    
    fc = front(pop(isfeasible == 1, ncr + 1 : ncr + nobj), m);
    pop(isfeasible == 1, ncr + nobj + 3) = fc(:, 2);
    
    cdc = crowdingdistance(pop(isfeasible == 1, ncr + 1 : ncr + nobj), fc, m);
    pop(isfeasible == 1, ncr + nobj + 4) = cdc;
    
    feasiblepop = pop(isfeasible == 1, :);
    infeasiblepop = pop(isfeasible == 0, :);
    initpop = zeros(npop, ncr + nobj + 6);
    
    if size(feasiblepop, 1) >= npop
        
        nf = max(fc(:, 2));
        n_front = zeros(nf, 1);
        
        for ii = 1:nf
            
            n_front(ii) = sum(fc(:, 2) == ii);
            
        end
        
        cn_front = cumsum(n_front);
        lf = find(cn_front >= npop, 1, 'first'); % last front
        
        nr = 0;
    
        if cn_front(lf) > npop
            if lf == 1
                nr = npop;
            else
                nr = npop - cn_front(lf-1); % number of remaining cromosomes
            end
            lastfront = fc(fc(:, 2) == lf, 1); % last front numbers
            lfc = feasiblepop(lastfront, ncr + nobj + 4); % last front crowding distances
            [~, so] = sort(lfc, 'descend');
            lcr = lastfront(so(1:nr)); % best cromosomes of last front
        end
        
        if nr == 0
            lf2 = lf;
        else
            lf2 = lf - 1;
        end
        
        sf = sortrows(fc, 2); % sorted front
        lc = find(sf(:, 2) == lf2, 1, 'last'); % last cromosome on the one before the last front
        initpop(1:npop - nr, :) = feasiblepop(sf(1:lc, 1), :);
        if nr ~= 0
            initpop(npop - nr + 1:npop, :) = feasiblepop(lcr, :);
        end
        
        
        nInitpop(i) = sum(initpop(:, ncr + nobj + 5));
    
    
    
        isfeasible = initpop(:, ncr + nobj + 5);
        sumviols = initpop(:, ncr + nobj + 6);
    
        fc = front(initpop(isfeasible == 1, ncr + 1 : ncr + nobj), m);
        initpop(isfeasible == 1, ncr + nobj + 3) = fc(:, 2);
    
        cdc = crowdingdistance(initpop(isfeasible == 1, ncr + 1 : ncr + nobj), fc, m);
        initpop(isfeasible == 1, ncr + nobj + 4) = cdc;
        

    else
        nfeasible = size(feasiblepop, 1);
        nremaining = npop - nfeasible;
        initpop(1 : nfeasible, :) = feasiblepop;
        infeasiblepop = sortrows(infeasiblepop, ncr + nobj + 6);
        infeasiblepop = flip(infeasiblepop);
        initpop(nfeasible + 1 : npop, :) = infeasiblepop(1 : nremaining, :);
        
    end
    
    
    % showing the result in each generation
    xf = initpop(:, 1);
    yf = initpop(:, 2);
    
    %pause(0.01);
    % plot3(xf, yf, zf, 'ob');
    plot(xf, yf, 'ob');
    axis([0 1.5 0 1.5]);
    pause(0.01);
    fprintf('generation: %g \n', i);
    
end