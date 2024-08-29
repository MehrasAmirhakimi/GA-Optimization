function parsedpop = PS(pop, id)

VarMin = id(:, 1); % lower limit for a variable
VarMax = id(:, 2); % upper limit for a variable
BIC = id(:, 3); % B: binary (0), I: integer (1), C: continous (2)
nVar = id(:, 4); % number of bits each variable occupy

nx = size(id, 1); % number of variables

cumnVar = cumsum(nVar);
VarRange = zeros(nx, 2);
VarRange(1, 1) = 1;
VarRange(2:nx, 1) = cumnVar(1:nx-1) + 1;
VarRange(:, 2) = cumnVar;

parsedpop = zeros(size(pop));

for i = 1:nx
    
    vr = VarRange(i, 1) : VarRange(i, 2);
    vmin = VarMin(i);
    vmax = VarMax(i);
    
    casenum = BIC(i);
    
    switch casenum
        case 0
            parsedpop(:, vr) = round(pop(:, vr));
        case 1
            parsedpop(:, vr) = floor((vmax - vmin + 1) * pop(:, vr)) + vmin;
        case 2
            parsedpop(:, vr) = (vmax - vmin) * pop(:, vr) + vmin;
    end
        
end

end