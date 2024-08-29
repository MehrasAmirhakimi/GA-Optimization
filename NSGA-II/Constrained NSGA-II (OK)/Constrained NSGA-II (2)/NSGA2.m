clc
clear all
close all

%% GA parameters

npop = 200;
ngen = 50;
m = [0, 0]; % minimization problem: 0 or maximization problem: 1
id = repmat([0; pi], [1, 2]);
nvar = size(id, 2); % number of variables
ncr = nvar; % each cromosome length
pc = 0.8; % probability of crossover
pm = 0.2; % probability of mutation
landa = 0.1;
mu = 0.1;
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
f = front(initpop(:, ncr + 1 : ncr + nobj), m);
initpop(:, ncr + nobj + 1) = f(:, 2);
% fc = front(initpop(isfeasible, ncr + 1 : ncr + nobj), m);
% initpop(isfeasible, ncr + nobj + 3) = fc(:, 2);

% calculating non-constraind and constrained crowding distance
cd = crowdingdistance(initpop(:, ncr + 1 : ncr + nobj), f, m);
initpop(:, ncr + nobj + 2) = cd;
% cdc = crowdingdistance(initpop(isfeasible, ncr + 1 : ncr + nobj), fc, m);
% initpop(isfeasible, ncr + nobj + 4) = cdc;


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
            c1 = binaryts(initpop(:, ncr + nobj + 1 : ncr + nobj + 2));
            c2 = binaryts(initpop(:, ncr + nobj + 1 : ncr + nobj + 2));
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
            c = binaryts(initpop(:, ncr + nobj + 1 : ncr + nobj + 2));
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
    
    % f = front(pop(:, ncr + 1 : ncr + nobj), m);
    % pop(:, ncr + nobj + 1) = f(:, 2);
    pop(:, ncr + nobj + 1) = 0;
    fc = front(pop(isfeasible, ncr + 1 : ncr + nobj), m);
    pop(isfeasible, ncr + nobj + 3) = fc(:, 2);

    
    % cd = crowdingdistance(pop(:, ncr + 1 : ncr + nobj), f, m);
    % pop(:, ncr + nobj + 2) = cd;
    pop(:, ncr + nobj + 2) = 0;
    cdc = crowdingdistance(pop(isfeasible, ncr + 1 : ncr + nobj), fc, m);
    pop(isfeasible, ncr + nobj + 4) = cdc;
    
    initpop = zeros(npop, ncr + nobj + 6);

    ffind = pop(:, ncr + nobj + 3) == 1;
    numpop = [1 : size(pop, 1)]';
    ffnum = numpop(ffind);
    
    [scdc, so] = sort(pop(ffnum, ncr + nobj + 4), 'descend');
    sffnum = ffnum(so);
    elitesnum = sffnum(1 : min(numel(sffnum), floor(npop / 1.5)));
    % elitesnum = sffnum;
    ne = numel(elitesnum);
    initpop(1 : ne, :) = pop(elitesnum, :);
    numpop(elitesnum) = [];
    rpop = pop(numpop, :);
    
    for j = ne + 1 : npop
        
        s = cbinaryts(rpop(:, ncr + nobj + 3 : end));
        initpop(j, :) = rpop(s, :);

    end
    
    initpop(:, ncr + nobj + 1 : ncr + nobj + 4) = 0;    
    isfeasible = initpop(:, ncr + nobj + 5);
    sumviols = initpop(:, ncr + nobj + 6);
    
    f = front(initpop(:, ncr + 1 : ncr + nobj), m);
    initpop(:, ncr + nobj + 1) = f(:, 2);
    
    cd = crowdingdistance(initpop(:, ncr + 1 : ncr + nobj), f, m);
    initpop(:, ncr + nobj + 2) = cd;
    
    fc = front(initpop(isfeasible == 1, ncr + 1 : ncr + nobj), m);
    initpop(isfeasible == 1, ncr + nobj + 3) = fc(:, 2);
    
    % showing the result in each generation
    ffandf = initpop(initpop(:, ncr + nobj + 3) == 1 & initpop(:, end-1) == 1, ncr + 1 : ncr + nobj);
    ffandi = initpop(initpop(:, ncr + nobj + 1) == 1 & initpop(:, end-1) == 0, ncr + 1 : ncr + nobj);
    % ffandf = initpop(initpop(:, end-1) == 1, ncr + 1 : ncr + nobj);
    % ffandi = initpop(initpop(:, end-1) == 0, ncr + 1 : ncr + nobj);
    
    xf = ffandf(:, 1);
    yf = ffandf(:, 2);
    % zf = ffandf(:, 3);
    
    xi = ffandi(:, 1);
    yi = ffandi(:, 2);
    % zi = ffandi(:, 3);
    
    pause(0.01);
    % plot3(xf, yf, zf, 'ob');
    plot(xf, yf, 'ob');
    hold on
    % plot3(xi, yi, zi, 'or');
    plot(xi, yi, 'or');
    hold off
    axis([0 1.5 0 1.5]);
    
    % Ibeamplot(initpop)
    
    fprintf('generation: %g \n', i);
    
end