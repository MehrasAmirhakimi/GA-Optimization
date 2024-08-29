clc
clear all
close all

%% GA parameters

npop = 100;
ngen = 200;
m = zeros(1, 3); % minimization problem: 0 or maximization problem: 1
id = repmat([10; -3; 3], [1, 2]);
nvar = size(id, 2); % number of variables
ncr = sum(id(1, :)); % each cromosome length
pc = 0.8; % probability of crossover
pm = 0.2; % probability of mutation
sdu = [0.7, 0.15, 0.15];
mu = 0.4;

parse = @(x) parsepop(x, id);
docrossover = @(x1, x2) crossover(x1, x2, sdu);
domutation = @(x) mutation(x, mu);
costfunction = @(x) Viennet(x); % this function has 2 outputs

%% Create initial population

initpop = zeros(npop, ncr + numel(m) + 2);
initpop(:, 1 : ncr) = randi([0 1], [npop, ncr]);
ppop = parse(initpop);
initpop(:, ncr + 1 : ncr + numel(m)) = costfunction(ppop);
f = front(initpop(:, ncr + 1 : ncr + numel(m)), m);
initpop(:, ncr + numel(m) + 1) = f(:, 2);
cd = crowdingdistance(initpop(:, ncr + 1 : ncr + numel(m)), f, m);
initpop(:, ncr + numel(m) + 2) = cd;


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
            c1 = binaryts(initpop(:, end-1:end));
            c2 = binaryts(initpop(:, end-1:end));
            x1 = initpop(c1, 1:ncr);
            x2 = initpop(c2, 1:ncr);
            [y1, y2] = docrossover(x1, x2);
            crosspop(jx-1, 1:ncr) = y1;
            crosspop(jx, 1:ncr) = y2;
        end
    end
    crosspop(jx+1:end, :)=[];
    pcrosspop = parse(crosspop);
    crosspop(:, ncr + 1 : ncr + numel(m)) = costfunction(pcrosspop);
    
    % do mutation
    
    mutpop = zeros(size(initpop));
    jm = 0;
    for im = 1:npop
        b = rand;
        if b < pm
            jm = jm+1;
            c = binaryts(initpop(:, end-1:end));
            x = initpop(c, 1:ncr);
            y = domutation(x);
            mutpop(jm, 1:ncr) = y;
        end
    end
    mutpop(jm+1:end, :)=[];
    pmutpop = parse(mutpop);
    mutpop(:, ncr + 1 : ncr + numel(m)) = costfunction(pmutpop);
    
    % going to next generation
    
    pop = [initpop; crosspop; mutpop];
    
    f = front(pop(:, ncr + 1 : ncr + numel(m)), m);
    pop(:, ncr + numel(m) + 1) = f(:, 2);
    
    cd = crowdingdistance(pop(:, ncr + 1 : ncr + numel(m)), f, m);
    pop(:, ncr + numel(m) + 2) = cd;
    
    nf = max(f(:, 2));
    n_front = zeros(nf, 1);
    
    for ii = 1:nf
        
        n_front(ii) = sum(f(:, 2) == ii);
        
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
        lastfront = f(f(:, 2) == lf, 1); % last front numbers
        lfc = pop(lastfront, ncr + numel(m) + 2); % last front crowding distances
        [~, so] = sort(lfc, 'descend');
        lcr = lastfront(so(1:nr)); % best cromosomes of last front
    end
    
    if nr == 0
        lf2 = lf;
    else
        lf2 = lf - 1;
    end
    
    sf = sortrows(f, 2); % sorted front
    lc = find(sf(:, 2) == lf2, 1, 'last'); % last cromosome on the one before the last front
    initpop(1:npop - nr, :) = pop(sf(1:lc, 1), :);
    if nr ~= 0
        initpop(npop - nr + 1:npop, :) = pop(lcr, :);
    end
    f = initpop(npop - nr + 1:npop, ncr + numel(m) + 1);
    c = initpop(npop - nr + 1:npop, ncr + 1 : ncr + numel(m));
    initpop(npop - nr + 1:npop, ncr + numel(m) + 2) = crowdingdistance(c, f, m);
    
    % showing the result in each generation
    
    if lf == 1
        n_front1 = npop;
    else
        n_front1 = n_front(1);
    end
    
    xy1 = initpop(1:n_front1, ncr + 1 : ncr + numel(m))';
    xf1 = xy1(1, :);
    yf1 = xy1(2, :);
    zf1 = xy1(3, :);
    
    pause(0.01);
    %plot(xf1, yf1, 'o');
    plot3(xf1, yf1, zf1, 'o');
    fprintf('generation: %g \n', i);
    
end