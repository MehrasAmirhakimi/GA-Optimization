function y = MixedMutate(x, id, mu)

xlength = numel(x);
nmu = ceil(mu * xlength);
nm = randsample(xlength, nmu);
VarMin = id(:, 1); % lower limit for a variable
VarMax = id(:, 2); % upper limit for a variable
BIC = id(:, 3); % B: binary (0), I: integer (1), C: continous (2)
nVar = id(:, 4); % number of bits each variable occupy
cumnVar = cumsum(nVar);
VarRange = zeros(nx, 2);
VarRange(1, 1) = 1;
VarRange(2:nx, 1) = cumnVar(1:nx-1) + 1;
VarRange(:, 2) = cumnVar;

for i = 1:numel(nm)
    
    j = nm(i);
    fVar = find(j <= cumnVar, 1, first);
    f = BIC(fVar);
    
    switch f
        case {0, 1}
            
        case 2
        
    end
    
end

    function y1 = im(x1, f)
        
    end

end