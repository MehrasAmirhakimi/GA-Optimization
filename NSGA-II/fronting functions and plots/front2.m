function f = front2(c, m)

% c: cost functrions
% m: min or maximization indicators
n = size(c, 1); % npop
ncr = [1:n]'; % cromosome numbering
nrc = n; % number of remaining cromosomes
rc = ncr; % remaining cromosomes
f = {}; % front
i = 0; % cell's row counter (front indice)


while nrc > 0 % building each front
    
    i = i + 1;
    %f(i, 1) = rc(1);
    %front = cell2mat(f(i, 1));
    front = rc(1);
    
    for k = 2:nrc % selecting each cromosome
        
        icr1 = rc(k);
        cr1 = c(icr1, :);
        nfront = numel(front);
        nnfront = zeros(1, nfront + 1);
        
        for j = 1:nfront % comparing selected cromosome with front
            
            icr2 = front(j);
            cr2 = c(icr2, :);
            d = dominate(cr1, cr2, m);
            
            if d == -1
                nnfront(1) = nnfront(1) + 0;
                nnfront(j + 1) = 1;
            elseif d == 0
                nnfront(1) = nnfront(1) + 1;
                nnfront(j + 1) = 1;
            else
                nnfront(1) = nnfront(1) + 1;
                nnfront(j + 1) = 0;
            end
            
            
        end
        
        
        if nnfront(1) == nfront
            
            front = icr1;
            
        end
        
        front = [front, front(nnfront(2:end) == 1)];
        
    end
    
    f(i, 1) = {front};
    ncr(front) = 0;
    rc = ncr(ncr > 0);
    nrc = numel(rc);
    
end
    
end


function d = dominate(f1, f2, m)

p1 = (f1 >= f2) == m;
p2 = (f1 > f2) == m;

if all(p1 == 0) | all(p2 == 0)
    d = -1;
elseif all(p1 == 1) | all(p2 == 1)
    d = 1;
else
    d = 0;
end

end